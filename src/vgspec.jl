struct VGSpec <: AbstractVegaSpec
    params::OrderedDict
end

function our_json_print(io, spec::VGSpec)
    JSON.print(io, getparams(spec))
end

# data is an array in vega
function vg_set_spec_data!(specdict, datait, name)
    updated = false
    recs = [OrderedDict{String,Any}(string(c[1]) => isa(c[2], DataValues.DataValue) ? (isna(c[2]) ? nothing : get(c[2])) : c[2] for c in zip(keys(r), values(r))) for r in datait]
    for def in specdict["data"]
        if def["name"] == name
            def["values"] = recs
            updated = true
        end
    end

    @assert updated "In data array, object must exist with matching name"
end

function (p::VGSpec)(data, name::String)
    TableTraits.isiterabletable(data) || throw(ArgumentError("'data' is not a table."))

    new_dict = copy(getparams(p))

    @assert haskey(new_dict, "data") "Must have data array in specification"

    it = IteratorInterfaceExtensions.getiterator(data)
    vg_set_spec_data!(new_dict, it, name)

    return VGSpec(new_dict)
end

function (p::VGSpec)(uri::URI, name::String)
    new_dict = copy(getparams(p))

    @assert haskey(new_dict, "data") "Must have data array in specification"

    updated = false
    for def in new_dict["data"]
        if def["name"] == name
            def["url"] = string(uri)
            updated = true
        end
    end

    @assert updated "In data array, object must exist with matching name"

    return VGSpec(new_dict)
end

function (p::VGSpec)(path::AbstractPath, name::String)
    new_dict = copy(getparams(p))

    @assert haskey(new_dict, "data") "Must have data array in specification"

    as_uri = string(URI(path))

    # TODO This is a hack that might only work on Windows
    # Vega seems to not understand properly formed file URIs
    if Sys.iswindows()
        as_uri = as_uri[1:5] * as_uri[7:end]
    end

    updated = false
    for def in new_dict["data"]
        if def["name"] == name
            def["url"] = as_uri
            updated = true
        end
    end

    @assert updated "In data array, object must exist with matching name"

    return VGSpec(new_dict)
end

"""
    deletedata!(spec::VGSpec)

Delete data from `spec` in-place.  See also [`deletedata`](@ref).
"""
function deletedata!(spec::VGSpec)
    for def in getparams(spec)["data"]
        haskey(def, "values") && delete!(def, "values")
        haskey(def, "url") && delete!(def, "url")
    end
    return spec
end

"""
    deletedata(spec::VGSpec)

Create a copy of `spec` without data.  See also [`deletedata!`](@ref).
"""
deletedata(spec::VGSpec) = deletedata!(copy(spec))

Base.:(==)(x::VGSpec, y::VGSpec) = getparams(x) == getparams(y)
