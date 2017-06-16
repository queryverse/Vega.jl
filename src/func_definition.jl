###################################################################
#   VegaLite public API definition
###################################################################

### list of VegaLite property names that need a new denomination in Julia
const sp2jl = Dict{Symbol,Symbol}(:type => :typ)
const jl2sp = Dict( (v,k) for (k,v) in sp2jl)

### conversion between property name in VegaLite and julia function name
jlfunc(vln::String) = jlfunc(Symbol(vln))
jlfunc(vln::Symbol) = Symbol("vl" * string(vln))
vlname(fn::Symbol)  = replace(string(fn), r"^vl", "")

### step 1 : identify functions to be created among all properties

needsfunction(s::IntDef)    = false
needsfunction(s::NumberDef) = false
needsfunction(s::BoolDef)   = false
needsfunction(s::StringDef) = false
needsfunction(s::VoidDef)   = false
needsfunction(s::AnyDef)    = false
needsfunction(s::ObjDef)    = true
needsfunction(s::RefDef)    = needsfunction(defs[s.ref])
needsfunction(s::UnionDef)  = any(needsfunction, s.items)
needsfunction(s::ArrayDef)  = needsfunction(s.items)
needsfunction(s::SpecDef)   = error("unknown type $(typeof(s))")

funcs2 = Dict{Symbol,Dict}()
for (def, ns) in deftree
  needsfunction(def) || continue

  if isa(def, UnionDef)  # remove non-object parts
    items   = filter(needsfunction, def.items)
    realdef = length(items)==1 ? items[1] : UnionDef("", items)
  else
    realdef = def
  end

  realdef = isa(realdef, RefDef) ? defs[realdef.ref] : realdef

  for (name, parentdef) in ns
    if name=="*" # if UnionDef look up one level
      nsp = deftree[parentdef]
      nns = unique(collect(v[1] for v in nsp))
      (length(nsp) > 1) && warn("which name ? $(join(nns, "," ))")
      sfn        = Symbol(nsp[1][1])
      realparent = nsp[1][2]
    else
      sfn = Symbol(name)
      realparent = parentdef
    end

    sfn2 = sfn == :plot ? :plot : jlfunc(sfn)
    haskey(funcs2, sfn2)          || (funcs2[sfn2]          = Dict())
    haskey(funcs2[sfn2], realdef) || (funcs2[sfn2][realdef] = Set())
    push!( funcs2[sfn2][realdef] , realparent )
  end
end

def2funcs = Dict{SpecDef,Any}()
for (k,v) in funcs2
  for def in keys(v)
    def2funcs[def] = push!( get(def2funcs, def, []), k )
  end
end

# length(funcs2)
# showall(keys(funcs2))

const arrayprops = Symbol[:layer, :transform, :hconcat, :vconcat]

### step 2 : declare functions

type VLSpec{T}
  params::Union{Dict, Vector}
end
vltype{T}(::VLSpec{T}) = T

for sfn in keys(funcs2)
  if isdefined(sfn)
    mt = @eval typeof($sfn).name.mt
    if isdefined(mt, :module) && mt.module != current_module()
      println("   importing $sfn from $(mt.module)")
      eval( Expr(:import, Symbol(mt.module), sfn) )
    end
  end

  specnm = Symbol(vlname(sfn)) # VegaLite property name
  @eval( function ($sfn)(args...;kwargs...)
           $(Expr(:curly, :VLSpec, QuoteNode(specnm)))( wrapper($(QuoteNode(sfn)), args...; kwargs...) )
         end  )

  # export
  eval( Expr(:export, sfn) )
end
