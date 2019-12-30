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

struct DataValuesNode
    columns::OrderedDict{Symbol,AbstractVector}

    function DataValuesNode(it)

        col_values, col_names = TableTraitsUtils.create_columns_from_iterabletable(it)
    
        return new(OrderedDict{Symbol,AbstractVector}(i[1]=>i[2] for i in zip(col_names,col_values)))
    end
end
  
Base.:(==)(a::DataValuesNode, b::DataValuesNode) = a.columns==b.columns

function our_show_json(io, it, col_names)
    print(io, "[")

    for (row_index, row) in enumerate(it)
        row_index==1 || print(io, ",")
        print(io, "{")

        for (col_index, col_value) in enumerate(row)
            col_index==1 || print(io, ",")
            JSON.print(io, col_names[col_index])
            print(io, ":")
            JSON.print(io, col_value isa DataValue ? get(col_value, nothing) : col_value)
        end

        print(io, "}")
    end

    print(io, "]")
end

function JSON.Writer.show_json(io::JSON.Writer.SC, ::JSON.Writer.CS, d::DataValuesNode)
    col_names = collect(keys(d.columns))
    it = TableTraitsUtils.create_tableiterator(collect(values(d.columns)), col_names)
    our_show_json(io, it, col_names)
end
