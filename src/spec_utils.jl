struct ObjectProxy
    params::Dict
end

abstract type AbstractVegaSpec end

Base.copy(spec::T) where {T <: AbstractVegaSpec} = T(copy(spec.params))

const ObjectLike = Union{AbstractVegaSpec, ObjectProxy}

getparams(spec) = getfield(spec, :params)

Base.propertynames(spec::ObjectLike) =
    [Symbol(key) for key in keys(spec.params)]

function Base.getproperty(spec::ObjectLike, name::Symbol)
    name === :params && return getparams(spec)
    params = getparams(spec)
    value = params[keytype(params)(name)]
    if value isa Dict
        return ObjectProxy(value)
    else
        return value
    end
end
