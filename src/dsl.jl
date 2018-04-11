### Shorcut functions

# ... x(typ=:quantitative, .. ))  => xquantitative()
# for chan in keys(refs["EncodingWithFacet"].props)
#   for typ in union(refs["BasicType"].enum, refs["GeoType"].enum)
#     sfn = Symbol(chan * typ)
#
#     # function declaration and export
#     schan = jlfunc(chan)
#     @eval(function ($sfn)(args...;kwargs...)
#             nkw = [kwargs ; (:type, $typ)]
#             ($schan)(args...;nkw...)
#           end)
#     eval( Expr(:export, sfn) )
#
#     # function documentation
#     sfn0 = jlfunc(chan)
#     eval(:( @doc (@doc $sfn0) $sfn ))
#   end
# end
#
# # encode_x()
# for chan in keys(refs["EncodingWithFacet"].props)
#     sfn = Symbol("encode_" * chan)
#
#     schan = jlfunc(chan)
#
#     @eval(function ($sfn)(field::Symbol, args...;kwargs...)
#         contains(i->i[1],kwargs,:field) && error("You cannot pass a keyword argument named 'field'.")
#         nkw = [kwargs ; (:field, field)]
#         encoding(($schan)(args...;nkw...))
#     end)
#
#     @eval(function ($sfn)(shorthand::String, args...;kwargs...)
#         parts = match(r"(\w+)(\(\w+\))?(:[QqOoNnTt])?", shorthand)
#
#         if parts[2]==nothing
#             field_name = parts[1]
#             agg_name = nothing
#         else
#             field_name = parts[2][2:end-1]
#             agg_name = parts[1]
#         end
#         vl_type = if parts[3]!=nothing && uppercase(parts[3][2:end])=="Q"
#             "quantitative"
#         elseif parts[3]!=nothing && uppercase(parts[3][2:end])=="O"
#             "ordinal"
#         elseif parts[3]!=nothing && uppercase(parts[3][2:end])=="N"
#             "nominal"
#         elseif parts[3]!=nothing && uppercase(parts[3][2:end])=="T"
#             "temporal"
#         else
#             nothing
#         end
#
#         parts = split(shorthand, ':')
#
#         nkw = [kwargs ; (:field, Symbol(field_name))]
#         if vl_type!=nothing
#           nkw = [nkw ; (:type, vl_type)]
#         end
#         if agg_name!=nothing
#           nkw = [nkw ; (:aggregate, String(agg_name))]
#         end
#
#         encoding(($schan)(args...;nkw...))
#     end)
#
#     eval( Expr(:export, sfn))
# end
#
# # ... mark(typ=:line .. ))  => markline()
# for typ in refs["Mark"].enum
#   sfn = Symbol("mark" * typ)
#
#   # function declaration and export
#   # styp = Symbol(typ)
#   @eval(function ($sfn)(args...;kwargs...)
#           nkw = [kwargs ; (:type, $typ)]
#           vlmark(args...;nkw...)
#         end)
#   eval( Expr(:export, sfn) )
#
#   # function documentation
#   sfn0 = jlfunc(:mark)
#   eval(:( @doc (@doc $sfn0) $sfn ))
# end
#
# # 1st level aliases
#
# import Base: repeat
#
# for sfn in [:config, :data, :transform, :selection, :encoding,
#             :layer, :spec, :facet, :hconcat, :vconcat, :repeat]
#   sfn0 = jlfunc(sfn)
#
#   @eval( function ($sfn)(args...;kwargs...)
#             ($sfn0)(args...;kwargs...)
#          end )
#   eval( Expr(:export, sfn) )
#
#   # documentation
#   eval(:( @doc (@doc $sfn0) $sfn ))
# end


### arguments processing

# function pushpars!(pars::Dict{String,Any}, val,
#                    prop::Symbol=Symbol())
#   if prop == Symbol()
#     isa(val, VLSpec) || error("non keyword args should use VegaLite function, not $val")
#     sprop = vltype(val)
#   else
#     sprop = get(jl2sp, prop, prop) # recover VegaLite name if different (typ => type)
#     isa(val, VLSpec) && sprop!=vltype(v) &&
#       error("expecting function $(jlfunc(sprop)) for keyword arg $prop, got $(vltype(val))")
#   end
#
#   cprop = string(sprop)
#   rval = isa(val, VLSpec) ? val.params : val
#   if sprop in arrayprops  # treat array of objects differently
#     if haskey(pars, string(sprop))
#       append!(pars[cprop], rval)
#     else
#       pars[cprop] = copy(rval)
#     end
#   elseif sprop == :plot # bag of key-values
#     merge!(pars, rval)
#   elseif sprop == :encoding
#     if haskey(pars, "encoding")
#       merge!(pars["encoding"], rval)
#     else
#       pars["encoding"] = rval
#     end
#   else
#     pars[cprop] = rval
#   end
#
#   pars
# end
#
#
# """
# process arguments (regular and keyword), check conformity against schema and
# wrap in a VLSpec type
# """
# function wrapper(sfn::Symbol, args...;kwargs...)
#   pars = Dict{String,Any}()
#
#   # first map the kw args to the fields in the definitions
#   foreach(t -> pushpars!(pars, t[2], t[1]), kwargs)
#
#   # now the other arguments
#   foreach(v -> pushpars!(pars, v), args)
#
#   if Symbol(vlname(sfn)) in arrayprops
#     pars = [pars]
#   end
#
#   # check if at least one of the SpecDef associated to this function match
#   # except if 1st level (i.e.  :plot) because this level can be built
#   # incrementally (with the pipe operator) and can be incomplete at
#   #  intermediate stages
#   if sfn != :plot
#     fdefs = collect(keys(funcs[sfn]))
#     conforms(pars, "$sfn", UnionDef("", fdefs))
#   end
#
#   pars
# end


########################  The VegaLite spec type  ########################

struct VLSpec{T}
    params::Union{Dict, Vector}
end

function VLSpec{VL}(args...;kwargs...) where VL
    params = todicttree(args...; kwargs...)

    # check if at least one of the SpecDef associated matches
    # except if 1st level (i.e.  :plot) because this level can be built
    # incrementally (with the pipe operator) and can be incomplete at
    #  intermediate stages
    # if VL != :plot
        fdefs = collect(keys(funcs[VL]))
        conforms(params, "$VL", UnionDef("", fdefs))
    # end

    VLSpec{VL}(params)
end

vltype(::VLSpec{T}) where T = T






"""
transforms arguments to a dict structure (dict) suitable for a VLSpec.
"""
function todicttree(args...; kwargs...)
    pars = Dict{String,Any}()

    # first process the kw args
    for (ksym,v) in kwargs
        # translate to VegaLite prop if needed (typ > type), and to a string
        kstr = String( get(jl2sp, ksym, ksym) )
        if v isa NamedTuple
            kwa = [ (ns,  getfield(v, ns)) for ns in fieldnames(typeof(v)) ]
            pars[kstr] = todicttree(;kwa...)
        elseif v isa Dict
            kwa = [ (Symbol(k),  val) for (k,val) in v ]
            pars[kstr] = todicttree(;kwa...)
        elseif v isa VLSpec
            pars[kstr] = Dict(vlname(vltype(v)) => v.params)
        else
            pars[kstr] = v
        end
    end

    # second the other arguments : they should be VLSpecs to ensure that
    #  they have a VL type (encoding, etc..) and that they are already processed
    #  (no named tuples, ...)
    for a in args
        isa(a, VLSpec) || error("non keyword args should be a VegaLite function, not $a")
        prop = vlname(vltype(a))
        haskey(pars, prop) && error("property $prop specified more than once")
        pars[prop] = a.params
    end

    # if Symbol(vlname(sfn)) in arrayprops
    #   pars = [pars]
    # end

    pars
end



### TableTraits.jl integration

# function vldata(d)
#     TableTraits.isiterabletable(d) || error("Only iterable tables can be passed to vldata.")
#
#     it = IteratorInterfaceExtensions.getiterator(d)
#
#     recs = [Dict(c[1]=>isa(c[2], DataValues.DataValue) ? (isnull(c[2]) ? nothing : get(c[2])) : c[2] for c in zip(keys(r), values(r))) for r in it]
#
#     VegaLite.VLSpec{:data}(Dict("values" => recs))
# end
#
# |>(a, b::VLSpec) = vldata(a) |> b


if false

methods(VLSpec)

methods(VLSpec, (Dict,))
methods(VLSpec, (VLSpec,))

VLSpec2{:vlmark}(typ=:point).params

ttt = VLSpec2{:vllayer}(mark=@NT(typ=:point),
                 encoding=@NT(x=@NT(typ=:nominal, field=:xx)),
                 width=300) ;

ttt = VLSpec{:vllayer}(encoding=@NT(x=@NT(typ=:nominal, field=:xx)),
                 width=300);

methods(VLSpec, (VLSpec,))

function mkfuncEDT(dim, typ)
    function (val, args...;kwargs...)
        l1 = VLSpec{dim}(args...;field=val, typ=typ, kwargs...)
        VLSpec{:vlencoding}(Dict(dim => l1.params))
    end
end

ttt = @NT( [ (:nominal,      mkfuncEDT(:vlx, :nominal)),
       (:quantitative, mkfuncEDT(:vlx, :quantitative))]... )

tlst = [:nominal, :quantitative, :ordinal, :temporal, :value]
ttt = @NT(nominal, quantitative, ordinal, temporal, value)
tmp = ttt([mkfuncEDT(:vlx, t) for t in tlst]...)


ttt = VLSpec{:vlx}(field=:yoyo, typ=:nominal, axis=nothing);
tt2 = VLSpec{:vlencoding}(Dict(:x => ttt.params));
tt2.params
vltype(ttt)
vlname(vltype(ttt))



ttt = tmp.nominal(:yoyo, axis=nothing);
ttt.params



ttt = VLSpec{:vlx}(typ=:nominal, field = :k);
ttt.params

tt2 = VLSpec{:vlencoding}(ttt);
tt2.params

tmp.nominal(field = :k)


methods(VLSpec)

p = res |>
    plot(mark.bar(),
         encoding.x.nominal(:src),
         encoding.y.quantitative(:val),
         encoding.color.nominal(:src),
         encoding.column.nominal(:cat),
         height=400, width=80);

end
