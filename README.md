# VegaLite.jl

_Julia bindings to Vega-Lite_

|Julia versions | master build | Coverage |
|:-------------:|:---------:|:-----------------------------:|:-----------:|
|[![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.5.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.5) [![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.6.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.6) | [![Build Status](https://travis-ci.org/fredo-dedup/VegaLite.jl.svg?branch=master)](https://travis-ci.org/fredo-dedup/VegaLite.jl) [![Build status](https://ci.appveyor.com/api/projects/status/b9cmmaquuc08n6uc/branch/master?svg=true)](https://ci.appveyor.com/project/fredo-dedup/vegalite-jl/branch/master) | [![Coverage Status](https://coveralls.io/repos/github/fredo-dedup/VegaLite.jl/badge.svg?branch=master)](https://coveralls.io/github/fredo-dedup/VegaLite.jl?branch=master) |


This package provides access to the VegaLite v2 high-level visualization grammar from Julia.

`Vega-Lite` (http://vega.github.io/vega-lite/) is a simpler version of the Vega grammar (see https://vega.github.io/vega/ and its associated Julia API https://github.com/johnmyleswhite/Vega.jl) allowing smaller and more expressive chart specifications. Parts of the VegaLite package (rendering functions, IJulia integration) are based on Vega.jl (thanks !).

Install with `Pkg.add("VegaLite")`. Most functions are documented, with the full list of their properties listed and explained, e.g. type `? vlconfig` to get the full list of properties of the `vlconfig` function.

All contributions, PR or issue, are welcome !

This package is essentially a thin layer between Julia and VegaLite that translates Julia statements into a JSON graph specification. Statements such as :

```julia
data(url="https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json") |>
  markcircle() |>
  encoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
           yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
           sizequantitative(aggregate=:count))
```

are translated to :
```JSON
{
  "encoding": {
    "x": {
      "bin": {
        "maxbins": 10
      },
      "field": "IMDB_Rating",
      "type": "quantitative"
    },
    "size": {
      "aggregate": "count",
      "type": "quantitative"
    },
    "y": {
      "bin": {
        "maxbins": 10
      },
      "field": "Rotten_Tomatoes_Rating",
      "type": "quantitative"
    }
  },
  "data": {
    "url": "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"
  },
  "mark": {
    "type": "circle"
  }
}
```

Giving the plot :

![plot1](examples/png/example1.png)

For a more detailed walk through of the Julia syntax see documentation.

When evaluated in the REPL, or in the Juno IDE, VegaLite statements trigger the opening of a browser window showing the plot. In IJulia the plot is shown in the result block below.

It is possible to render the plots to file (supported formats are svg, png and pdf) by calling :
- `savefig(filename, plot)` with the file format guesssed form the file extension of `filename`
- or svg(filename, plot), pdf(filename, plot) or pdf(filename, plot)


## Examples:

### Simple scatter plot

```julia
using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

VegaLite.data(mpg) |> # add values ('data' need the VegaLite module qualification because it is exported by RDatasets too)
  markpoint() |>
  encoding(xquantitative(field=:Cty, axis=nothing),
           yquantitative(field=:Hwy, vlscale(zero=false)),
           colornominal(field=:Manufacturer)) |>    # bind color to :Manufacturer, nominal scale
  config(vlcell(width=350, height=400))
```

![plot1](examples/png/vegalite3.png)


### Stack multiple plots with `hconcat` and `vconcat`

```julia
data_values(mpg) +
  mark_point() +
  encoding_column_ord(:Cyl) +  # sets the column facet dimension
  encoding_row_ord(:Year) +    # sets the row facet dimension
  encoding_x_quant(:Displ) +
  encoding_y_quant(:Hwy) +
  encoding_size_quant(:Cty) +
  encoding_color_nominal(:Manufacturer)

```



### Using the `repeat` statement to facet a plot by fields

```julia
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
                yquantitative(vlfield(repeat=:row))))```

![plot1](examples/png/example2.png)
