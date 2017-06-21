### Shorcut functions

# ... x(typ=:quantitative, .. ))  => xquantitative()
for chan in keys(refs["EncodingWithFacet"].props)
  for typ in refs["Type"].enum
    sfn = Symbol(chan * typ)

    # function declaration and export
    schan = jlfunc(chan)
    @eval(function ($sfn)(args...;kwargs...)
            nkw = [kwargs ; (:type, $typ)]
            ($schan)(args...;nkw...)
          end)
    eval( Expr(:export, sfn) )

    # function documentation
    sfn0 = jlfunc(chan)
    eval(:( @doc (@doc $sfn0) $sfn ))
  end
end

# ... mark(typ=:line .. ))  => markline()
for typ in refs["Mark"].enum
  sfn = Symbol("mark" * typ)

  # function declaration and export
  # styp = Symbol(typ)
  @eval(function ($sfn)(args...;kwargs...)
          nkw = [kwargs ; (:type, $typ)]
          vlmark(args...;nkw...)
        end)
  eval( Expr(:export, sfn) )

  # function documentation
  sfn0 = jlfunc(:mark)
  eval(:( @doc (@doc $sfn0) $sfn ))
end

# 1st level aliases

import Base: repeat

for sfn in [:config, :data, :transform, :selection, :encoding,
            :layer, :spec, :facet, :hconcat, :vconcat, :repeat]
  sfn0 = jlfunc(sfn)

  @eval( function ($sfn)(args...;kwargs...)
            ($sfn0)(args...;kwargs...)
         end )
  eval( Expr(:export, sfn) )

  # documentation
  eval(:( @doc (@doc $sfn0) $sfn ))
end


### arguments processing

function pushpars!(pars::Dict{String,Any}, val,
                   prop::Symbol=Symbol())
  if prop == Symbol()
    isa(val, VLSpec) || error("non keyword args should use VegaLite function, not $val")
    sprop = vltype(val)
  else
    sprop = get(jl2sp, prop, prop) # recover VegaLite name if different (typ => type)
    isa(val, VLSpec) && sprop!=vltype(v) &&
      error("expecting function $(jlfunc(sprop)) for keyword arg $prop, got $(vltype(val))")
  end

  cprop = string(sprop)
  rval = isa(val, VLSpec) ? val.params : val
  if sprop in arrayprops  # treat array of objects differently
    if haskey(pars, string(sprop))
      append!(pars[cprop], rval)
    else
      pars[cprop] = rval
    end
  elseif sprop == :plot # bag of key-values
    merge!(pars, rval)
  else
    pars[cprop] = rval
  end

  pars
end


"""
process arguments (regular and keyword), check conformity against schema and
wrap in a VLSpec type
"""
function wrapper(sfn::Symbol, args...;kwargs...)
  pars = Dict{String,Any}()

  # first map the kw args to the fields in the definitions
  foreach(t -> pushpars!(pars, t[2], t[1]), kwargs)

  # now the other arguments
  foreach(v -> pushpars!(pars, v), args)

  if Symbol(vlname(sfn)) in arrayprops
    pars = [pars]
  end

  # check if at least one of the SpecDef associated to this function match
  # except if 1st level (i.e.  :plot) because this level can be built
  # incrementally (with the pipe operator) and can be incomplete at
  #  intermediate stages
  if sfn != :plot
    fdefs = collect(keys(funcs[sfn]))
    conforms(pars, "$sfn", UnionDef("", fdefs))
  end

  pars
end



### pipe operator definition

function |>(a::VLSpec, b::VLSpec)
  parsa = if isa(a,VLSpec{:plot})
            a.params
          else
            Dict{String, Any}(string(vltype(a)) => a.params)
          end

  parsb = if isa(b,VLSpec{:plot})
            b.params
          else
            Dict{String, Any}(string(vltype(b)) => b.params)
          end

  pars = copy(parsa)
  foreach( t -> pushpars!(pars, t[2], Symbol(t[1])), parsb )

  VLSpec{:plot}(pars)
end
