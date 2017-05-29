module A
end

include("schema_parsing.jl")

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

#####################################################################

function mkdoc(spec::UnionDef, context::Symbol, padding)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  push!(docstr, "One of : ", "")
  for (i,v) in enumerate(spec.items)
    fs = needsfunction(v) ? "`$context(<keyword args..>)`" : "`$context=...`"
    push!(docstr, "  - _case #$i_ $fs")
    v.desc != "" && push!(docstr, "", v.desc)
    push!(docstr, "")
    append!(docstr, mkdoc(v, Symbol(""), 4))
  end
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::ObjDef, context::Symbol, padding)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  for (k,v) in spec.props
    dstrs = mkdoc(v, Symbol(k), 2)
    dstrs[1] = "* `$k` : " * dstrs[1]
    append!(docstr, dstrs)
    # push!(docstr, "")
  end
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::RefDef, context::Symbol, padding)
  mkdoc(defs[spec.ref], context, padding)
end

function mkdoc(spec::IntDef, context::Symbol, padding)
  docstr = String[]
  push!(docstr, "(Int) ", spec.desc)
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::NumberDef, context::Symbol, padding)
  docstr = String[]
  push!(docstr, "(Number) ", spec.desc)
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::StringDef, context::Symbol, padding)
  docstr = String[]
  push!(docstr, "(String) ", spec.desc)
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::BoolDef, context::Symbol, padding)
  docstr = String[]
  push!(docstr, "(Boolean) ", spec.desc)
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::ArrayDef, context::Symbol, padding)
  docstr = String[]
  push!(docstr, "(Array of $(typeof(spec.items))) ", spec.desc)
  repeat(" ", padding) .* docstr
end

function mkdoc(spec::VoidDef, context::Symbol, padding)
  push!(docstr, "(Void) ", spec.desc)
  repeat(" ", padding) .* docstr
end

(sfn, def) = first(funcs)
ks = first(keys(def))

ds = mkdoc(ks,:padding, 0)
s = join(rstrip.(ds), "\n")

@doc "$s" padding
println(s)
@doc(s, padding)

for (sfn, dvs) in take(funcs,3)
  println("documenting $sfn")
  docstr = String[]
  for (def, fns) in dvs
    flist = join("`" .* unique(fns) .* "`", ", ", " and ")
    push!(docstr, "## `$sfn` as in $flist")
    append!(docstr, mkdoc(def, sfn, 0))
    push!(docstr, "")
  end
  println( join(rstrip.(docstr), "\n") )
end


ds = ["abcd", "sdf"]

broadcast(.*, "  ", ds)


haskey(funcs, :broadcast)

rpad

s = """
# `padding`
The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle. This can be a single number or an object with `"top"`, `"left"`, `"right"`, `"bottom"` properties.

*Default value*: `5`

One of :
  * Case #1
    - `left` (Number, default = 1)
    - `bottom` (Number, default = 1)
    - `right` (Number, default = 1)
    - `top` (Number, default = 1)
  * Case #2 :
    Number
"""

a = 1
@doc s a

Docs.doc!(Docs.Binding(A,:a), s)














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
