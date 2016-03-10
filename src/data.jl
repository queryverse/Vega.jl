

function data_values(;values...)
  length(values)==0 && error("no values given")

  ks = [v[1] for v in values]
  vs = [v[2] for v in values]

  n    = length(values[1][2])
  any(v -> length(v) != n, vs) && error("all values must have the same length")

  vss = [ Dict(zip(ks, [v[i] for v in vs])) for i in  1:n ]
  VegaLiteVis(Dict(:data => Dict(:values => vss)))
end
