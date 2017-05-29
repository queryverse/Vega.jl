# module A
# end

include("schema_parsing.jl")

###################################################################
#   function creation
###################################################################

type VLSpec{T}
  params::Dict{Symbol, Any}
end

vltype{T}(::VLSpec{T}) = T

const jl2sp = Dict{Symbol,Symbol}(:_range => :range,
                                  :_repeat => :repeat,
                                  :_mark => :mark,
                                  :_scale => :scale,
                                  :_bind => :bind,
                                  :_bin => :bin,
                                  :_filter => :filter,
                                  :_equal => :equal,
                                  :_values => :values,
                                  :_cell => :cell,
                                  :_sort => :sort,
                                  :_color => :color,
                                  :_column => :column,
                                  :_detail => :detail,
                                  :_opacity => :opacity,
                                  :_order => :order,
                                  :_row => :row,
                                  :_shape => :shape,
                                  :_size => :size,
                                  :_text => :text,
                                  :_x => :x,
                                  :_x2 => :x2,
                                  :_y => :y,
                                  :_y2 => :y2,
                                  :_type => :type
                                  )

const sp2jl = Dict( (v,k) for (k,v) in jl2sp)

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

# defs["plot"]

######## list function to be created with their associated definitions

funcs = Dict{Symbol,Any}()
for (pos, name, spec, typ, needsfunc) in ns
  sname = pos=="plot" ? :plot : Symbol(name)  # plot is for root def
  sname == :* && continue
  !needsfunc && continue

  fn = get(sp2jl, sname, sname)
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

funcs[:plot]

showall(collect(keys(funcs)))
length(funcs) # 68
sum(p -> length(p.second), collect(funcs)) # 148 definitions
sum(p -> length(p.second), collect(funcs)) # 83 definitions

for (sfn, def) in funcs
  sfn == :plot && continue # different, defined later
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
end

function plot(args...;kwargs...)
  pars = wrapper(args...;kwargs...)
  # conforms(pars, defs["plot"], "", false)
  VLPlot(JSON.json(pars))
end


#####################################################################

function mkdoc(spec::UnionDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  push!(docstr, "One of : ")
  for (i,v) in enumerate(spec.items)
    fs = needsfunction(v) ? "`$context(<keyword args..>)`" : "`$context=...`"
    push!(docstr, "  - _case #$(i)_ $fs $(v.desc)")
    # v.desc != "" && push!(docstr, "", v.desc)
    # push!(docstr, "")
    append!(docstr, mkdoc(v, Symbol(""), 4))
  end
  repeat(" ", indent) .* docstr
end

# haskey(funcs, :_bind)
# get(sp2jl, :bind, :bind)
function mkdoc(spec::ObjDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  for (k,v) in spec.props
    sk = Symbol(k)
    sk = get(sp2jl, sk, sk)
    if haskey(funcs, sk)
      push!(docstr, "* `$sk` : _see `?$sk`_")
    else
      dstrs = mkdoc(v, sk, 2)
      dstrs[1] = "* `$sk` : " * dstrs[1]
      append!(docstr, dstrs)
    end
    # push!(docstr, "")
  end
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::RefDef, context::Symbol, indent)
  mkdoc(defs[spec.ref], context, indent)
end

function mkdoc(spec::IntDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Int) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::NumberDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Number) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::StringDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(String) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::BoolDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Boolean) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::ArrayDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Array of $(typeof(spec.items))) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::VoidDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Void) ")
  repeat(" ", indent) .* docstr
end

# (sfn, dvs) = first(funcs)
# ks = first(keys(def))
#
# ds = mkdoc(ks,:padding, 0)
# s = join(rstrip.(ds), "\n")
#
# mkdoc(NumberDef(""), :test, 0)
#
# @doc "$s" padding
# println(s)
# @doc(s, padding)

for (sfn, dvs) in funcs #take(funcs,10)
  # println("documenting $sfn")
  docstr = String[]
  for (def, fns) in dvs
    # (def, fns) = first(dvs)
    flist = join("`" .* unique(fns) .* "`", ", ", " and ")
    push!(docstr, "## `$sfn` as in $flist")
    append!(docstr, mkdoc(def, sfn, 0))
    push!(docstr, "")
  end
  # println( join(rstrip.(docstr), "\n") )
  Docs.doc!(Docs.Binding(current_module(),sfn),
            Docs.docstr(join(rstrip.(docstr), "\n")))
  # println()
  # println()
end
#
# sfn = :plot
# @doc "abcd" -> sfn
#
#
# funcs[:plot]
#
#
# a = 1
# @doc s a
#
# s = "abcd"
# Docs.doc!(Docs.Binding(A,:a), Docs.docstr(s))
#
# @doc(s, $sfn)








#
#
# ds = mkdoc(ks,0)
# s = reduce((a,b) -> a*b, "", ds)
# @doc "$s" padding
#
#


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
