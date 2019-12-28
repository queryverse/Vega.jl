struct ObjectProxy
    params::Dict
end

abstract type AbstractVegaSpec end

Base.copy(spec::T) where {T <: AbstractVegaSpec} = T(copy(getparams(spec)))

const ObjectLike = Union{AbstractVegaSpec, ObjectProxy}

getparams(spec) = getfield(spec, :params)

Base.propertynames(spec::ObjectLike) =
    [Symbol(key) for key in keys(getparams(spec))]

function Base.getproperty(spec::ObjectLike, name::Symbol)
    if name === :params
        Base.depwarn(
            """
            Using `spec.params["NAME"]` to obtain vega-lite property is deprecated.
            Please use `spec.NAME` instead.
            """,
            :getproperty,
        )
        return getparams(spec)
    end
    params = getparams(spec)
    value = params[keytype(params)(name)]
    if value isa Dict
        return ObjectProxy(value)
    else
        return value
    end
end

Setfield.set(spec::ObjectLike, ::typeof(@lens getparams(_)), params) =
    typeof(spec)(params)

function Setfield.set(spec::ObjectLike, ::PropertyLens{name}, value) where name
    params = copy(getparams(spec))
    params[keytype(params)(name)] = _maybeparams(value)
    @set getparams(spec) = params
end

_maybeparams(value) = value
_maybeparams(value::ObjectLike) = getparams(value)

struct InlineData
    columns::OrderedDict{Symbol,Type}
    data::String
end
  
Base.:(==)(a::InlineData, b::InlineData) = a.columns==b.columns && a.data==b.data
  
JSON.lower(d::InlineData) = JSON.JSONText(d.data)

function InlineData(it)
    col_names = fieldnames(eltype(it))
    col_types = [fieldtype(eltype(it),i) for i in col_names]

    buffer = IOBuffer()

    print(buffer, "{")
    JSON.print(buffer, "values")
    print(buffer, ":[")

    for (row_index, row) in enumerate(it)
        row_index==1 || print(buffer, ",")
        print(buffer, "{")

        for (col_index, col_value) in enumerate(row)
            col_index==1 || print(buffer, ",")
            JSON.print(buffer, col_names[col_index])
            print(buffer, ":")
            JSON.print(buffer, col_value isa DataValue ? get(col_value, nothing) : col_value)
        end

        print(buffer, "}")
    end

    print(buffer, "]}")        

    return InlineData(OrderedDict{Symbol,Type}(i[1]=>i[2] for i in zip(col_names,col_types)), String(take!(buffer)))
end
