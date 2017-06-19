using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe


### first define 3 graphs

r1 = encoding(xquantitative(field=:Cty, axis=nothing),
              yquantitative(field=:Hwy, vlscale(zero=false)),
              colornominal(field=:Manufacturer)) ;

# A slope graph:

r21 = markline() |>
      encoding(xordinal(field=:Year,
                    vlaxis(labelAngle=-45, labelPadding=10),
                    vlscale(rangeStep=50)),
               yquantitative(field=:Hwy, aggregate=:mean),
               colornominal(field=:Manufacturer)) ;
r21.params
VegaLite.vltype(r21)

layer(r21)

r22 = VegaLite.data(mpg) |>
 markrect() |>
 encoding(xquantitative(field=:Displ, vlbin(maxbins=5)),
          yquantitative(field=:Hwy, vlbin(maxbins=5)),
          colornominal(field=:Manufacturer)) ;

VegaLite.data(mpg) |>
  vconcat(encoding(xquantitative(field=:Cty, axis=nothing),
                yquantitative(field=:Hwy, vlscale(zero=false)),
                colornominal(field=:Manufacturer))) |>
  vconcat(r21)

typeof(r1)
