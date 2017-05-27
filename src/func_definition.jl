
###################################################################
#   function creation
###################################################################

# first step : list the functions to be created

ns = Any[]


needsfunction(s::IntDef) = false
needsfunction(s::NumberDef) = false
needsfunction(s::BoolDef) = false
needsfunction(s::StringDef) = false
needsfunction(s::VoidDef) = false

needsfunction(s::ObjDef) = true
needsfunction(s::RefDef) = true

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

for (k,v) in defs
  lookinto!(v, k)
end
# ns
ns

type VLSpec{T}
  params::Dict{Symbol, Any}
end

vltype{T}(::VLSpec{T}) = T

sp2jl = Dict(:type => :typ)
jl2sp = Dict( (v,k) for (k,v) in sp2jl)

fdefs = Dict{Symbol, Any}()
for (pos, name, spec, typ, hasfunc) in ns
  name == "*" && continue
  name == "plot" && continue # different, defined later
  !hasfunc && continue

  fn = get(sp2jl, name, name)
  sfn = Symbol(fn)

  if !haskey(fdefs, name)  # function not defined already

    println("defining $fn $(fn==name ? "" : "(formerly $name)")")
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
end

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
