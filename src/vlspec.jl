###############################################################################
#
#   Definition of VLSpec type and associated functions
#
###############################################################################

struct VLSpec{T}
    params::Union{Dict, Vector}
end
vltype(::VLSpec{T}) where T = T

function (p::VLSpec{:plot})(data)
    TableTraits.isiterabletable(data) || throw(ArgumentError("'data' is not a table."))

    it = IteratorInterfaceExtensions.getiterator(data)
    recs = [Dict(c[1]=>isa(c[2], DataValues.DataValue) ? (isnull(c[2]) ? nothing : get(c[2])) : c[2] for c in zip(keys(r), values(r))) for r in it]

    new_dict = copy(p.params)
    new_dict["data"] = Dict{String,Any}("values" => recs)

    return VLSpec{:plot}(new_dict)
end

function (p::VLSpec{:plot})(uri::URI)
    new_dict = copy(p.params)
    new_dict["data"] = Dict{String,Any}("url" => string(uri))

    return VLSpec{:plot}(new_dict)
end
