abstract type AbstractVegaFragment end

struct VGFrag <: AbstractVegaFragment
    positional::Vector{Any}
    named::OrderedDict{String,Any}
end

function vgfrag(args...; kwargs...)
    return VGFrag(Any[args...], OrderedDict{String,Any}(string(k) => convert_nt_to_dict(v, VGFrag) for (k, v) in kwargs))
end

convert_nt_to_dict(item, fragtype) = item

function convert_nt_to_dict(item::NamedTuple, fragtype)
    return fragtype(Any[], OrderedDict{String,Any}(string(k) => convert_nt_to_dict(v, fragtype) for (k, v) in pairs(item)))
end

function convert_nt_to_dict(item::AbstractVegaFragment, fragtype)
    return fragtype(item.positional, OrderedDict{String,Any}(string(k) => convert_nt_to_dict(v, fragtype) for (k, v) in pairs(item.named)))
end

function walk_dict(f, d::T, parent) where {T <: AbstractDict}
    res = T()
    for p in d
        if p[2] isa Dict
            new_p = f(p[1] => walk_dict(f, p[2], p[1]), parent)

            if new_p isa Vector
                for i in new_p
                    res[i[1]] = i[2]
                end
            elseif new_p isa Pair
                res[new_p[1]] = new_p[2]
            else
                error("Invalid return type.")
            end
        else
            new_p = f(p, parent)
            if new_p isa Vector
                for i in new_p
                    res[i[1]] = i[2]
                end
            elseif new_p isa Pair
                res[new_p[1]] = new_p[2]
            else
                error("Invalid return type.")
            end
        end
    end
    return res
end

replace_remaining_frag(frag) = frag

replace_remaining_frag(frag::AbstractDict) = error("THIS SHOULDN'T HAPPEN $frag")

function replace_remaining_frag(frag::AbstractVector)
    return [replace_remaining_frag(i) for i in frag]
end

function replace_remaining_frag(frag::AbstractVegaFragment)
    if !isempty(frag.positional)
        error("There is an unknown positional argument in this spec.")
    else
        return OrderedDict{String,Any}(k => replace_remaining_frag(v) for (k, v) in frag.named)
    end
end

function fix_shortcut_vg_data(v)
    if v isa Pair
        if v[2] isa AbstractPath
            as_uri = string(URI(v[2]))
            return VGFrag([], OrderedDict{String,Any}("url" => Sys.iswindows() ? as_uri[1:5] * as_uri[7:end] : as_uri))
        elseif v[2] isa URI
            as_uri = string(v[2])
            return VGFrag([], OrderedDict{String,Any}("url" => Sys.iswindows() && v[2].scheme == "file" ? as_uri[1:5] * as_uri[7:end] : as_uri))
        elseif TableTraits.isiterabletable(v[2])
            it = IteratorInterfaceExtensions.getiterator(v[2])
            return VGFrag([], OrderedDict{String,Any}("name" => string(v[1]), "values" => DataValuesNode(it)))
        end
    elseif v isa VGFrag
        new_dict = copy(v.named)
        if haskey(new_dict, "values") && TableTraits.isiterabletable(new_dict["values"])
            it = IteratorInterfaceExtensions.getiterator(new_dict["values"])
            new_dict["values"] = DataValuesNode(it)
        end
        return VGFrag([], new_dict)
    else
        return v
    end
end

function fix_shortcut_level_spec(spec_frag::VGFrag)
    spec = copy(spec_frag.named)

    if haskey(spec, "data")
        spec["data"] = [fix_shortcut_vg_data(i) for i in spec["data"]]
    end

    return VGFrag([], spec)
end

function convert_frag_tree_to_dict(spec::VGFrag)
    # At this point all positional arguments should have been replaced
    # and we can convert everything into a plain Dict structure
    isempty(spec.positional) || error("There shouldn't be any positional argument left.")

    return OrderedDict{String,Any}(k => replace_remaining_frag(v) for (k, v) in spec.named)
end

function vgplot(args...;kwargs...)
    return VGSpec(convert_frag_tree_to_dict(fix_shortcut_level_spec(vgfrag(args...;kwargs...))))
end
