macro vl_str(content)
    return VLSpec{:plot}(JSON.parse(content))
end

function walk_dict(f, d, parent)
    res = Dict()
    for p in d
        if p[2] isa Dict
            new_p = f(p[1]=>walk_dict(f, p[2], p[1]), parent)

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

function decode_shorthand(shorthand::AbstractString)
    parts = match(r"(\w+)(\(((\w+)|\*)\))?(:[QqOoNnTt])?", shorthand)
  
    if parts[2]==nothing
        field_name = parts[1]
        agg_name = nothing
    else
        field_name = parts[2][2:end-1]
        agg_name = parts[1]
    end
  
    vl_type = if parts[5]!=nothing && uppercase(parts[5][2:end])=="Q"
        "quantitative"
    elseif parts[5]!=nothing && uppercase(parts[5][2:end])=="O"
        "ordinal"
    elseif parts[5]!=nothing && uppercase(parts[5][2:end])=="N"
        "nominal"
    elseif parts[5]!=nothing && uppercase(parts[5][2:end])=="T"
        "temporal"
    else
        nothing
    end
  
    return field_name, agg_name, vl_type
  end

function fix_shortcuts(spec::Dict)
    # Replace a first mark shortcut
    if any(i->i[1]=="mysuperdupa", spec)
        spec["mark"] = spec["mysuperdupa"]
        delete!(spec, "mysuperdupa")
    end

    new_spec = walk_dict(spec, "root") do p, parent
        if p[1] == "mysuperdupa" && (parent=="mark")
            return "type" => p[2]
        elseif p[1] == "mysuperdupa"
            field_name, agg_name, vl_type = decode_shorthand(string(p[2]))
            asdf = [:field=>field_name]
            if agg_name!==nothing
                asdf = [asdf; :aggregate=>agg_name]
            end
            if vl_type!==nothing
                asdf = [asdf; :type=>vl_type]
            end
            return asdf
        elseif p[1]=="typ"
            return "type"=>p[2]
        else
            return p
        end
    end

    if haskey(new_spec, "enc")
        new_spec["encoding"] = new_spec["enc"]
        delete!(new_spec, "enc")
    end

    if haskey(new_spec, "encoding")
        new_encoding_dict = Dict{String,Any}()
        for (k,v) in new_spec["encoding"]
            if v isa Symbol
                new_encoding_dict[k] = Dict("field"=>string(v))
            elseif v isa String
                field_name, agg_name, vl_type = decode_shorthand(v)
                new_dict = Dict("field"=>field_name)                
                if agg_name!==nothing
                    new_dict["aggregate"] = agg_name
                end
                if vl_type!==nothing
                    new_dict["type"] = vl_type
                end  
                new_encoding_dict[k] = new_dict
            else
                new_encoding_dict[k] = v
            end
        end
        new_spec["encoding"] = new_encoding_dict
    end

    if haskey(new_spec, "data")
        if TableTraits.isiterabletable(new_spec["data"])
            it = IteratorInterfaceExtensions.getiterator(new_spec["data"])

            recs = [Dict(c[1]=>isa(c[2], DataValues.DataValue) ? (isnull(c[2]) ? nothing : get(c[2])) : c[2] for c in zip(keys(r), values(r))) for r in it]
        
            new_spec["data"] = Dict{String,Any}("values" => recs)
        end
    end

    return new_spec
end

macro vlplot(ex...)
    ex = :({$(ex...)})
    new_ex = MacroTools.prewalk(ex) do x
        # @show x
        if x isa Expr && x.head==:(=) && x.args[2] isa Symbol
            return :($(string(x.args[1]))=>$(esc(x.args[2])))
        elseif x isa Expr && x.head==:(=)
                return :($(string(x.args[1]))=>$(x.args[2]))
        elseif x isa Expr && x.head==:cell1d
            args = Vector{Expr}(length(x.args))
            for (i,v) in enumerate(x.args)
                if v isa Expr && v.head==:(=)
                    args[i] = v
                else
                    args[i] = Expr(:(=), :mysuperdupa, v)
                end
            end
            return :(Dict{Any,Any}($(args...)))
        else
            return x
        end
    end

    return :( VegaLite.VLSpec{:plot}(fix_shortcuts($new_ex)) )
end

function Base.:+(a::VLSpec{:plot}, b::VLSpec{:plot})
    new_spec = deepcopy(a.params)
    if haskey(new_spec, "facet") || haskey(new_spec, "repeat")
        new_spec["spec"] = deepcopy(b.params)
    else
        if !haskey(new_spec,"layer")
            new_spec["layer"] = []
        end
        push!(new_spec["layer"], deepcopy(b.params))
    end
    
    return VLSpec{:plot}(new_spec)
end

function Base.hcat(A::VLSpec{:plot}...)
    spec = VLSpec{:plot}(Dict{String,Any}())
    spec.params["hconcat"] = []
    for i in A
        push!(spec.params["hconcat"], deepcopy(i.params))
    end
    return spec
end

function Base.vcat(A::VLSpec{:plot}...)
  spec = VLSpec{:plot}(Dict{String,Any}())
  spec.params["vconcat"] = []
  for i in A
      push!(spec.params["vconcat"], deepcopy(i.params))
  end
  return spec
end

function interactive()
    i -> begin
        i.params["selection"] = Dict{String,Any}()
        i.params["selection"]["selector001"] = Dict{String,Any}()
        i.params["selection"]["selector001"]["type"] = "interval"
        i.params["selection"]["selector001"]["bind"] = "scales"
        i.params["selection"]["selector001"]["encodings"] = ["x", "y"]
        i.params["selection"]["selector001"]["on"] = "[mousedown, window:mouseup] > window:mousemove!"
        i.params["selection"]["selector001"]["translate"] = "[mousedown, window:mouseup] > window:mousemove!"
        i.params["selection"]["selector001"]["zoom"] = "wheel!"
        i.params["selection"]["selector001"]["mark"] = Dict("fill"=>"#333", "fillOpacity"=>0.125, "stroke"=>"white")
        i.params["selection"]["selector001"]["resolve"] = "global"
        return i
    end
end