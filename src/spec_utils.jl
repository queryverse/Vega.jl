abstract type AbstractVegaSpec end

Base.copy(spec::T) where {T <: AbstractVegaSpec} = T(copy(spec.params))
