
"""
Sets the data source
data_values(*sym1*=*vec1*, *sym2*=*vec2*, ...)

Adds data vectors (`vec1`, `vec1`,..) and binds each of them to a symbol (`sym1`, `sym2`, ...)
"""
function data_values(;values...)
  if length(values)==0
    return i->data_values(i)
  end

  ks = [v[1] for v in values]
  vs = [v[2] for v in values]

  n    = length(values[1][2])
  any(v -> length(v) != n, vs) && error("all values must have the same length")

  vss = [ Dict(zip(ks, [v[i] for v in vs])) for i in  1:n ]
  VegaLiteVis(Dict(:data => Dict(:values => vss)))
end
