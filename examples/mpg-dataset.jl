using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

# Scatter plot

VegaLite.data(mpg) |>                   # add values (qualify 'data' because it is exported by RDatasets too)
  markpoint() |>                        # mark type = points
  encoding(xquantitative(field=:Cty),   # bind x dimension to :Cty field in mpg
           yquantitative(field=:Hwy))   # bind y dimension to :Hwy field in mpg

# Scatter plot with color encoding manufacturer

mpg |>
  markpoint() |>
  encoding(xquantitative(field=:Cty, axis=nothing),
           yquantitative(field=:Hwy, vlscale(zero=false)),
           colornominal(field=:Manufacturer)) |>    # bind color to :Manufacturer, nominal scale
  config(vlcell(width=350, height=400))

# A slope graph:

mpg |>
  markline() |>
  encoding(xordinal(field=:Year,
                    vlaxis(labelAngle=-45, labelPadding=10),
                    vlscale(rangeStep=50)),
           yquantitative(field=:Hwy, aggregate=:mean),
           colornominal(field=:Manufacturer))

# A facetted plot:

mpg |>
  markpoint() |>
  encoding(columnordinal(field=:Cyl), # sets the column facet dimension
           rowordinal(field=:Year),   # sets the row facet dimension
           xquantitative(field=:Displ),
           yquantitative(field=:Hwy),
           sizequantitative(field=:Cty),
           colornominal(field=:Manufacturer))


# A table:

mpg |>
  marktext() |>
  encoding(columnordinal(field=:Cyl),
           rowordinal(field=:Year),
           textquantitative(field=:Displ, aggregate=:mean)) |>
  config(vlmark(fontStyle="italic", fontSize=15, font="helvetica"))
