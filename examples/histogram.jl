using VegaLite
using DataFrames

# a simple histogram of random standard normal draws
DataFrame(x=randn(200)) |>
  markbar() |>
  encoding(xquantitative(field=:x, vlbin(maxbins=20), vlaxis(title="values")),
           yquantitative(field=:*, aggregate=:count, vlaxis(title="number of draws"))
           )
