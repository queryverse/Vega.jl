struct VGSpec <: AbstractVegaSpec
    params::Union{Dict, Vector}
end

Base.:(==)(x::VGSpec, y::VGSpec) = x.params == y.params
