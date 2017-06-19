using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe


### first define 3 graphs

r1 = markline() |>
     encoding(xquantitative(field=:Cty, axis=nothing),
              yquantitative(field=:Hwy, vlscale(zero=false)),
              colornominal(field=:Manufacturer)) ;

r2 = markrect() |>
      encoding(xquantitative(field=:Displ, vlbin(maxbins=5)),
               yquantitative(field=:Hwy, vlbin(maxbins=5)),
               colornominal(field=:Manufacturer)) ;

mpg |>
  vconcat(r1) |>
  vconcat(r2) |>
  config(vlcell(width=400))
