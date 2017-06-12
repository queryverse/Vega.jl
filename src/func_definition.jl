###################################################################
#   function creation
###################################################################

# const jl2sp = Dict{Symbol,Symbol}(:_range => :range,
#                                   :_repeat => :repeat,
#                                   :_mark => :mark,
#                                   :_scale => :scale,
#                                   :_bind => :bind,
#                                   :_bin => :bin,
#                                   :_filter => :filter,
#                                   :_equal => :equal,
#                                   :_values => :values,
#                                   :_cell => :cell,
#                                   :_sort => :sort,
#                                   :_color => :color,
#                                   :_column => :column,
#                                   :_detail => :detail,
#                                   :_opacity => :opacity,
#                                   :_order => :order,
#                                   :_row => :row,
#                                   :_shape => :shape,
#                                   :_size => :size,
#                                   :_text => :text,
#                                   :_x => :x,
#                                   :_x2 => :x2,
#                                   :_y => :y,
#                                   :_y2 => :y2,
#                                   :_type => :type,
#                                   :_data => :data
#                                   )

### list of VegaLite property names that need a new denomination in Julia
const sp2jl = Dict{Symbol,Symbol}(:type => :typ)
const jl2sp = Dict( (v,k) for (k,v) in sp2jl)

### conversion between property name in VegaLite and julia function name
jlfunc(vln::String) = jlfunc(Symbol(vln))
jlfunc(vln::Symbol) = Symbol("vl" * string(vln))
vlname(fn::Symbol)  = (string(fn))[3:end]


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

### step 3 : declare functions

type VLSpec{T}
  params::Dict{String, Any}
end
vltype{T}(::VLSpec{T}) = T

function wrapper(sfn::Symbol, args...;kwargs...)
  pars = Dict{String,Any}()

  # first map the kw args to the fields in the definitions
  for (f,v) in kwargs
    jf = string(get(jl2sp, f, f))  # recover VegaLite name if different
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
    jf = string(vltype(v))
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

  # check if at least one of the SpecDef associated to this function match
  fdefs = collect(keys(funcs[sfn]))
  conforms(pars, "$sfn()", UnionDef("", fdefs))

  pars
end

# keys(funcs)

for (sfn, def) in funcs
  sfn == :plot && continue # treated differently, see below

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

function plot(args...;kwargs...)
  pars = wrapper(:plot, args...;kwargs...)

  # of six possible plot objects (unit, layer, repeat, hconcat, etc..),
  # identify which one applies by their required properties to simplify
  # error messages (i.e. to avoid too many "possible causes" )
  onematch = false
  for spec in defs["plot"].items
    if all(r in keys(pars) for r in spec.required)
      conforms(pars, "plot(..", spec)
      onematch = true
    end
  end

  # if no match print full error message
  onematch || conforms(pars, "plot(..", defs["plot"])

  VLPlot(JSON.json(pars))
end

export plot
