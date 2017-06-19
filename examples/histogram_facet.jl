using VegaLite
using DataFrames

## histograms by group

df= DataFrame(group=rand(0:1, 200))
df[:x] = df[:group]*2 + randn(size(df,1))

df |>
  facet(columnnominal(field=:group)) |>
  spec(markbar(),
       encoding(xquantitative(field=:x, vlbin(maxbins=15)),
                yquantitative(field=:*, aggregate=:count),
                colornominal(field=:group)))
