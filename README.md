# VegaLite.jl

_Julia bindings to Vega-Lite_

|Julia 0.3 | Julia 0.4 | master (on nightly + release) | Coverage |
|:--------:|:---------:|:-----------------------------:|:-----------:|
|[![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.3.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.3) | [![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.4.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.4) | [![Build Status](https://travis-ci.org/fredo-dedup/VegaLite.jl.svg?branch=master)](https://travis-ci.org/fredo-dedup/VegaLite.jl) | [![Coverage Status](https://coveralls.io/repos/fredo-dedup/VegaLite.jl/badge.png?branch=master)](https://coveralls.io/r/fredo-dedup/VegaLite.jl?branch=master) |

This package provides access to the Vega-lite charting library from Julia (see http:http://vega.github.io/vega-lite/).

Install with `Pkg.add("ReverseDiffSource")` (or Pkg.clone("https://github.com/fredo-dedup/VegaLite.jl.git") while its not in the official repository).

Examples:

```julia
using VegaLite
using RDatasets

mpg = dataset("ggplot2", "mpg") # load the 'mpg' dataframe

data_values(mpg) +            # add values
  mark_point() +              # mark type = points
  encoding_x_quant(:Cty) +
  encoding_y_quant(:Hwy)
```

![plot1](examples/png/vega (1).png)

```julia
data_values(mpg) +
  mark_point() +
  encoding_x_quant(:Cty, axis=false) +
  encoding_y_quant(:Hwy, scale=scale(zero=false)) +
  encoding_color_nominal(:Manufacturer) +
  config_cell(width=350, height=400)

data_values(mpg) +
  mark_line() +
  encoding_x_ord(:Year,
                 axis  = axis(labelAngle=-45, labelAlign="right"),
                 scale = scale(bandSize=50)) +
  encoding_y_quant(:Hwy, aggregate="mean") +
  encoding_color_nominal(:Manufacturer)

data_values(mpg) +
  mark_point() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_x_quant(:Displ) +
  encoding_y_quant(:Hwy) +
  encoding_size_quant(:Cty) +
  encoding_color_nominal(:Manufacturer)

data_values(mpg) +
  mark_text() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_text_quant(:Displ, aggregate="mean") +
  config_mark(fontStyle="italic", fontSize=12, font="courier")
```
