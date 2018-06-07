# VegaLite.jl

_Julia bindings to Vega-Lite_

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://fredo-dedup.github.io/VegaLite.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://fredo-dedup.github.io/VegaLite.jl/latest)
[![Build Status](https://travis-ci.org/fredo-dedup/VegaLite.jl.svg?branch=master)](https://travis-ci.org/fredo-dedup/VegaLite.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/b9cmmaquuc08n6uc/branch/master?svg=true)](https://ci.appveyor.com/project/fredo-dedup/vegalite-jl/branch/master)
[![VegaLite](http://pkg.julialang.org/badges/VegaLite_0.6.svg)](http://pkg.julialang.org/?pkg=VegaLite&ver=0.6)
[![Coverage Status](https://coveralls.io/repos/github/fredo-dedup/VegaLite.jl/badge.svg?branch=master)](https://coveralls.io/github/fredo-dedup/VegaLite.jl?branch=master)
[![codecov](https://codecov.io/gh/fredo-dedup/VegaLite.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/fredo-dedup/VegaLite.jl)

## Overview

[VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl) is a plotting package for the [julia](https://julialang.org/) programming language. The package is based on [Vega-Lite](https://vega.github.io/vega-lite/), which extends a traditional [grammar of graphics](https://doi.org/10.1007/0-387-28695-0) API into a [grammar of interactive graphics](https://doi.org/10.1109/TVCG.2016.2599030).

[VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl) allows you to create a wide range of statistical plots. It exposes the full functionality of the underlying [Vega-Lite](https://vega.github.io/vega-lite/) and is a the same time tightly integrated into the julia ecosystem. Here is an example of a scatter plot:

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot(
    :point,
    x=:Horsepower,
    y=:Miles_per_Gallon,
    color=:Origin,
    width=400,
    height=400
)
```
![plot](examples/png/readme_plot1.svg)

## Installation

To install [VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl), run the following julia code:

```julia
Pkg.add("VegaLite")
```

## Documentation

The current documentation can be found [here](https://fredo-dedup.github.io/VegaLite.jl/stable).
