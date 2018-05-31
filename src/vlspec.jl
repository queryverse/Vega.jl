###############################################################################
#
#   Definition of VLSpec type and associated functions
#
###############################################################################

struct VLSpec{T}
    params::Union{Dict, Vector}
end
vltype(::VLSpec{T}) where T = T
