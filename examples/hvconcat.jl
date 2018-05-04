using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

r1 = (mk.line(interpolate="monotone"),
      enc.x.quantitative(:Cty, scale=@NT(zero=false)),
      enc.y.quantitative(:Hwy, scale=@NT(zero=false)),
      enc.color.nominal(:Manufacturer)) ;

r2 = (mk.rect(),
      enc.x.quantitative(:Displ, bin=@NT(maxbins=20)),
      enc.y.quantitative(:Hwy, bin=@NT(maxbins=10)),
      enc.color.quantitative(:*, aggregate=:count)) ;

mpg |>
  plot(vconcat([r1,r2]))
