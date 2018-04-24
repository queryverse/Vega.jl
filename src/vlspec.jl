###############################################################################
#
#   Definition of VLSpec type and associated functions
#
###############################################################################

struct VLSpec{T}
    params::Union{Dict, Vector}
end
vltype(::VLSpec{T}) where T = T

"""
creates a new VLSpec from the arguments provided
"""
function mkSpec(VL::Symbol, args...;kwargs...)
    params = todicttree(args...; kwargs...)

    # check if at least one of the SpecDef associated matches
    fdefs = collect(keys(funcs[VL]))
    conforms(params, "$VL", UnionDef("", fdefs))

    VLSpec{VL}(params)
end




"""
transforms arguments to a dict structure (dict) suitable for a VLSpec.
"""
function todicttree(args...; kwargs...)
    ####  pass 1 : collect prop => value pairs
    pars = Pair{Union{String,Void},Any}[]

    # kw args
    for (ksym,v) in kwargs
        # translate to VegaLite prop if needed (typ > type), and to a string
        kstr = String( get(jl2sp, ksym, ksym) )
        v2= if v isa NamedTuple
                kwa = [ (ns,  getfield(v, ns)) for ns in fieldnames(typeof(v)) ]
                todicttree(;kwa...)
            elseif v isa Dict
                kwa = [ (Symbol(k),  val) for (k,val) in v ]
                todicttree(;kwa...)
            elseif v isa Tuple  # accepted if all elements have a prop (VLSpecs)
                all( isa(e, VLSpec) for e in v) || error("tuple $v is not all VLSpecs")
                kwa = [ (Symbol(vlname(vltype(e))), e.params) for (k,val) in v ]
                todicttree(;kwa...)
            elseif v isa VLSpec
                Dict(vlname(vltype(v)) => v.params)
            else
                v
            end
        push!(pars, kstr => v2)
    end

    # positional arguments
    for a in args
        if isa(a, VLSpec)
            push!(pars, vlname(vltype(a)) => a.params)
        elseif a isa Tuple  # accepted if all elements have a prop (VLSpecs)
            all( isa(e, VLSpec) for e in a) || error("tuple $a is not all VLSpecs")
            push!(pars, nothing => Dict([ Symbol(vlname(vltype(e))) => e.params for e in a ]...) )
        else
            push!(pars, nothing => a)
        end
    end

    #### pass 2 : separate cases the params are all propertyless from the other
    # cases. In the former case they could be fields for an ArrayObj
    #   such as data, or transform, etc....

    if all( p[1]==nothing for p in pars )
        return length(pars)==1 ? pars[1][2] : [ p[2] for p in pars ]

    elseif all( p[1]!=nothing for p in pars )
        pars2 = Dict{String,Any}()
        for p in pars
            if haskey(pars2, p[1])
                pars2[p[1]] = fuse(pars2[p[1]], p[2])
            else
                pars2[p[1]] = p[2]
            end
        end
        return pars2
    else
        error("inconsistent args in ($args ; $kwargs)")
    end
end

function fuse(a::Dict, b::Dict)
    na = copy(a)
    for (k,v) in b
        if haskey(a, k)
            na[k] = fuse(na[k], v)
        else
            na[k] = v
        end
    end
    na
end

function fuse(a, b)
    [a, b]
end

# function todicttree(args...; kwargs...)
#     #  pass 1 : collect prop => value pairs
#     pars = Dict{String,Any}()
#
#     # first process the kw args
#     for (ksym,v) in kwargs
#         # translate to VegaLite prop if needed (typ > type), and to a string
#         kstr = String( get(jl2sp, ksym, ksym) )
#         if v isa NamedTuple
#             kwa = [ (ns,  getfield(v, ns)) for ns in fieldnames(typeof(v)) ]
#             pars[kstr] = todicttree(;kwa...)
#         elseif v isa Dict
#             kwa = [ (Symbol(k),  val) for (k,val) in v ]
#             pars[kstr] = todicttree(;kwa...)
#         elseif v isa VLSpec
#             pars[kstr] = Dict(vlname(vltype(v)) => v.params)
#         else
#             pars[kstr] = v
#         end
#     end
#
#     # second the other arguments : they should be VLSpecs to ensure that
#     #  they have a VL type (encoding, etc..) and that they are already processed
#     #  (no named tuples, ...)
#     for a in args
#         isa(a, VLSpec) || error("non keyword args should be a VegaLite function, not $a")
#         prop = vlname(vltype(a))
#         haskey(pars, prop) && error("property $prop specified more than once")
#         pars[prop] = a.params
#     end
#
#     # if Symbol(vlname(sfn)) in arrayprops
#     #   pars = [pars]
#     # end
#
#     pars
# end
