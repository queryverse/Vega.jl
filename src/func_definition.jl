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


### step 1 : list all the property names

lookinto!(s::SpecDef, path) = nothing

function lookinto!(s::ObjDef,  path)
  for (k,v) in s.props
    push!(ns, (path, k, v))
    lookinto!(v, [path; k])
  end
end

function lookinto!(s::UnionDef,  path)
  for v in s.items
    push!(ns, (path, "*", v))
    lookinto!(v, [path; "*"])
  end
end

ns = Any[]
for (k,v) in defs
  lookinto!(v, [k])
end
# ns

### step 2 : identify functions to be created among all properties

needsfunction(s::IntDef) = false
needsfunction(s::NumberDef) = false
needsfunction(s::BoolDef) = false
needsfunction(s::StringDef) = false
needsfunction(s::VoidDef) = false
needsfunction(s::ObjDef) = true
needsfunction(s::RefDef) = needsfunction(defs[s.ref])
needsfunction(s::UnionDef) = any(needsfunction, s.items)
needsfunction(s::ArrayDef) = needsfunction(s.items)
needsfunction(s::SpecDef) = error("unknown type $(typeof(s))")

funcs = Dict{Symbol,Any}()
for (path, name, spc) in ns
  needsfunction(spc) || continue

  if path==["plot"] # plot is for root def
    sfn = :plot
  else
    name == "*" && continue
    sfn = jlfunc(name)
  end

  if !haskey(funcs, sfn)
    funcs[sfn] = Dict{SpecDef, Vector}( spc => [path] )
  else
    ss  = collect(keys(funcs[sfn]))
    idx = findfirst( ss .== spc )
    if idx != 0  # new definition
      push!(funcs[sfn][ss[idx]], path)
    else # equivalent definition already seen
      funcs[sfn][spc] = [path]
    end
  end
end

# showall(collect(keys(funcs)))
# haskey(funcs, :mark)
# length(funcs) # 68
# sum(p -> length(p.second), collect(funcs)) # 148 definitions
# sum(p -> length(p.second), collect(funcs)) # 98 definitions

# for (sfn, def) in funcs
#   any( isa(d, ArrayDef) for d in keys(def) ) || continue
#   println(sfn)
#   if all( isa(d, ArrayDef) for d in keys(def) ) # all are arrays
#   else
#     println("problem")
#   end
# end
# 'range' prop can be an object or an array => will parse badly
# funcs[:vlrange]

const arrayprops = Symbol[:layer, :transform, :hconcat, :vconcat]

### step 3 : declare functions

type VLSpec{T}
  params::Union{Dict, Vector}
end
vltype{T}(::VLSpec{T}) = T


for (sfn, def) in funcs
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
