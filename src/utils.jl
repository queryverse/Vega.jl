### Shorcut functions

# ... x(typ=:quantitative, .. ))  => xquantitative()
for chan in keys(defs["EncodingWithFacet"].props)
  for typ in defs["Type"].enum
    sfn = Symbol(chan * typ)

    # function declaration and export
    schan = jlfunc(chan)
    @eval(function ($sfn)(args...;kwargs...)
            nkw = [kwargs ; (:type, $typ)]
            ($schan)(args...;nkw...)
            # pars = wrapper(args...; kwargs...)
            # pars["type"] = $typ
            # $(Expr(:curly, :VLSpec, QuoteNode(schan)))( pars )
          end)
    eval( Expr(:export, sfn) )

    # function documentation
    sfn0 = jlfunc(chan)
    eval(:( @doc (@doc $sfn0) $sfn ))
  end
end

# ... mark(typ=:line .. ))  => markline()
for typ in defs["Mark"].enum
  sfn = Symbol("mark" * typ)

  # function declaration and export
  # styp = Symbol(typ)
  @eval(function ($sfn)(args...;kwargs...)
          nkw = [kwargs ; (:type, $typ)]
          vlmark(args...;nkw...)
          # pars = wrapper(args...; kwargs...)
          # pars["type"] = $typ
          # $(Expr(:curly, :VLSpec, QuoteNode(:mark)))( pars )
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



### pipe operator definition
import Base: |>

function |>(a::VLSpec, b::VLSpec)
  parsa = isa(a,VLSpec{:plot}) ? a.params :
           Dict{String, Any}(string(vltype(a)) => a.params)

  parsb = isa(b,VLSpec{:plot}) ? b.params :
          Dict{String, Any}(string(vltype(b)) => b.params)

  pars = copy(parsa)
  for (k,v) in parsb
    # if multiple arguments of the same type (eg layers) transform to an array
    if haskey(pars, k)
      if isa(pars[k], Vector)
        push!(pars[k], v)
      else
        pars[k] = [pars[k], v]
      end
    else
      pars[k] = v
    end
  end

  VLSpec{:plot}(pars)
end

# function |>(a::VLSpec, b::VLSpec)
#   pars = merge(a.params, b.params)
#   VLSpec{:plot}(pars)
# end

export |>
