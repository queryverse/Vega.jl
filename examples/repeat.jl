using Distributions
using DataTables
using VegaLite

renderer(:canvas)

xs = rand(Normal(), 100, 3)
dt = DataTable(a = xs[:,1] + xs[:,2] .^ 2,
               b = xs[:,3] .* xs[:,2],
               c = xs[:,3] .+ xs[:,2])

VegaLite.data(dt) |>
  repeat(column = [:a, :b, :c], row = [:a, :b, :c]) |>
  config(vlcell(width=100, height=100)) |>
  spec(markpoint(),
       encoding(xquantitative(vlfield(repeat=:column)),
                yquantitative(vlfield(repeat=:row))))
