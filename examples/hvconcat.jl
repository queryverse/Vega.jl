using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

r1 = markline(interpolate="monotone") |>
     encoding(xquantitative(field=:Cty, vlscale(zero=false)),
              yquantitative(field=:Hwy, vlscale(zero=false)),
              colornominal(field=:Manufacturer)) ;

r2 = markrect() |>
      encoding(xquantitative(field=:Displ, vlbin(maxbins=20)),
               yquantitative(field=:Hwy, vlbin(maxbins=10)),
               colorquantitative(aggregate=:count)) ;

mpg |>
  vconcat(r1) |>
  vconcat(r2) |>
  config(vlcell(width=400))
