# VegaLite.jl

_Julia bindings to Vega-Lite_

|Julia 0.4 | Julia 0.5 | master (on nightly + release) | Coverage |
|:--------:|:---------:|:-----------------------------:|:-----------:|
|[![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.4.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.4) | [![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.5.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.5) | [![Build Status](https://travis-ci.org/fredo-dedup/VegaLite.jl.svg?branch=master)](https://travis-ci.org/fredo-dedup/VegaLite.jl) | [![Coverage Status](https://coveralls.io/repos/github/fredo-dedup/VegaLite.jl/badge.svg?branch=master)](https://coveralls.io/github/fredo-dedup/VegaLite.jl?branch=master) |


This package provides access to the Vega-Lite high-level visualization grammar (http://vega.github.io/vega-lite/) from Julia.

Vega-Lite is a simpler version of the Vega grammar allowing smaller and more expressive chart specifications. If you don't find this library powerful enough for your needs you can turn to Vega.jl (https://github.com/johnmyleswhite/Vega.jl) on which this project is partially based (thanks !).

Install with `Pkg.add("VegaLite")` (or `Pkg.clone("https://github.com/fredo-dedup/VegaLite.jl.git")`
until it reaches the official repository). You can use the integrated documentation, e.g. `? config_mark` to get the full list of properties of the `config_mark` function.

The julia functions follow pretty closely the Vega-Lite JSON format: `data_values()` creates the `{"data": {values: { ...} }}` part of the spec file, etc.
Only two functions are added:
- `svg(Bool)` : sets the drawing mode of the plots, SVG if `true`, canvas if `false`. Default = `true`
- `buttons(Bool)` : indicates if the plot should be accompanied with links 'Save as PNG', 'View source' and 'Open in Vega Editor'.

Currently, VegaLite.jl works with IJulia/Jupyter, Escher and in the standard REPL (a browser window will open).


All contributions, PR or issue, are welcome !


##Examples:

- Plotting a simple line chart:
```julia
using VegaLite

ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

v = data_values(time=ts, res=ys) +    # add the data vectors & assign to symbols 'time' and 'res'
      mark_line() +                   # mark type = line
      encoding_x_quant(:time) +       # bind x dimension to :time, quantitative scale
      encoding_y_quant(:res)          # bind y dimension to :res, quantitative scale
```

![plot1](examples/png/vega (1).png)

- Scatterplot, using a DataFrame as the source:
```julia
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

data_values(mpg) +            # add values
  mark_point() +              # mark type = points
  encoding_x_quant(:Cty) +    # bind x dimension to :Cty field in mpg
  encoding_y_quant(:Hwy)      # bind y dimension to :Hwy field in mpg
```

![plot1](examples/png/vega (2).png)

- A scatterplot, with colors and size settings for the plot:
```julia
data_values(mpg) +
  mark_point() +
  encoding_x_quant(:Cty, axis=false) +
  encoding_y_quant(:Hwy, scale=scale(zero=false)) +
  encoding_color_nominal(:Manufacturer) +    # bind color to :Manufacturer, nominal scale
  config_cell(width=350, height=400)

```

![plot1](examples/png/vega (3).png)

- A slope graph:
```julia
data_values(mpg) +
  mark_line() +
  encoding_x_ord(:Year,
                 axis  = axis(labelAngle=-45, labelAlign="right"),
                 scale = scale(bandSize=50)) +
  encoding_y_quant(:Hwy, aggregate="mean") +
  encoding_color_nominal(:Manufacturer)

```

![plot1](examples/png/vega (4).png)

- A trellis plot:
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

![plot1](examples/png/vega (5).png)

- A table:
```julia
data_values(mpg) +
  mark_text() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_text_quant(:Displ, aggregate="mean") +
  config_mark(fontStyle="italic", fontSize=12, font="courier")
```

![plot1](examples/png/vega (6).png)
