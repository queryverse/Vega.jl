
###################################################################
#   function creation
###################################################################

type VLSpec{T}
  params::Dict{Symbol, Any}
end

vltype{T}(::VLSpec{T}) = T

sp2jl = Dict(:type => :typ)
jl2sp = Dict( (v,k) for (k,v) in sp2jl)


# first step : list all the property names

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


lookinto!(s::SpecDef, pos) = nothing

function lookinto!(s::ObjDef,  pos)
  for (k,v) in s.props
    push!(ns, (pos, k, v, typeof(v), needsfunction(v)))
    lookinto!(v, "$pos-$k")
  end
end

function lookinto!(s::UnionDef,  pos)
  for v in s.items
    push!(ns, (pos, "*", v, typeof(v), needsfunction(v)))
    lookinto!(v, "$pos-*")
  end
end

ns = Any[]
for (k,v) in defs
  lookinto!(v, k)
end
# ns
ns

######## list function to be created with their associated definitions

funcs = Dict{Symbol,Any}()
for (pos, name, spec, typ, needsfunc) in ns
  name == "*" && continue
  name == "plot" && continue # different, defined later
  !needsfunc && continue

  fn = get(sp2jl, name, name)
  sfn = Symbol(fn)

  if !haskey(funcs, sfn)
    funcs[sfn] = Dict{SpecDef, Vector}( spec => [pos;])
  else
    ss  = collect(keys(funcs[sfn]))
    idx = findfirst( ss .== spec )
    if idx != 0  # defintion already seen
      push!(funcs[sfn][ss[idx]], pos)
    else
      funcs[sfn][spec] = [pos;]
    end
  end
end

length(funcs) # 67
sum(p -> length(p.second), collect(funcs)) # 148 definitions
sum(p -> length(p.second), collect(funcs)) # 83 definitions

sort(collect(funcs), by= p -> -length(p.second))
k = collect(keys(funcs[:condition]))

for (sfn, def) in funcs
  println("defining $sfn")
  if isdefined(sfn)
    mt = @eval typeof($sfn).name.mt
    if isdefined(mt, :module) && mt.module != current_module()
      println("   importing $sfn from $(mt.module)")
      eval( Expr(:import, Symbol(mt.module), sfn) )
    end
  end

  try
    @eval( function ($sfn)(args...;kwargs...)
             $(Expr(:curly, :VLSpec, QuoteNode(sfn)))( wrapper(args...; kwargs...) )
           end  )
  catch e
    println(e)
  end

  # create function documentation


end
(sfn, def) = first(funcs)
ks = first(keys(def))
ds = " `$sfn` \n"
ds *= "One of : \n"
for spec in ks
  ds *=
first(ks.items)

using Base.Markdown

r = mkdoc(first(ks.items),2)
md"$r"




show(md"# ABCD")

function mkdoc(spec::UnionDef, padding)
  docstr = String[]
  push!(docstr, spec.desc * "\n")
  push!(docstr, "One of : \n")
  for (i,v) in enumerate(spec.items)
    push!(docstr, "  * Case #$i : $(v.desc)\n")
    append!(docstr, mkdoc(v, padding+2))
  end
  docstr
end

function mkdoc(spec::ObjDef, padding)
  docstr = String[]
  push!(docstr, spec.desc)
  for (k,v) in spec.props
    fstr =  "  * `$k` "
    fstr *= "(Number, default = 1)"
    v.desc != "" && (fstr *= " : $(v.desc)")
    fstr *= "\n"
    push!(docstr, fstr)
  end
  for s in docstr
    s = repeat(" ", padding) * s
  end
  docstr
end

function mkdoc(spec::SpecDef, padding)
  docstr = String[]
  push!(docstr, "Number")
  push!(docstr, spec.desc)
  for s in docstr
    s = repeat(" ", padding) * s
  end
  docstr
end


ds = mkdoc(ks,0)
s = reduce((a,b) -> a*b, "", ds)
@doc "$s" padding


function plot(args...;kwargs...)
  pars = wrapper(args...;kwargs...)
  # conforms(pars, defs["plot"], "", false)
  VLPlot(JSON.json(pars))
end



function wrapper(args...;kwargs...)
  pars = Dict{Symbol,Any}()

  # first map the kw args to the fields in the definitions
  for (f,v) in kwargs
    jf = get(jl2sp, f, f)
    if isa(v, VLSpec)
      (vltype(v) == f) || error("expecting function $f for keyword arg $f, got $(vltype(v))")
      pars[jf] = v.params
    else
      pars[jf] = v
    end
  end

  # now the other arguments
  for v in args
    isa(v, VLSpec) || error("non keyword args should be using a VegaLite function, not $v")
    f = vltype(v)
    jf = get(jl2sp, f, f)
    # if multiple arguments of the same type (eg layers) transform to an array
    if haskey(pars, jf)
      if isa(pars[jf], Vector)
        push!(pars[jf], v.params)
      else
        pars[jf] = [pars[jf], v.params]
      end
    else
      pars[jf] = v.params
    end
  end

  pars
end
