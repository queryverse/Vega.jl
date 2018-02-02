## Vega-lite specifications

A vega-lite specification is represented as a `VLSpec` object in julia.
There are multiple ways to create a `VLSpec` object. The previous section
demonstrated the use of the julia API to create these specification objects.
This section describes three additional ways to create and interact with
these specification objects: the `vl` string macro, functions that load
and save specifications from and to disc, and the
[DataVoyager.jl](https://github.com/davidanthoff/DataVoyager.jl) package.

### The `vl` string macro

One can embed a JSON vega-lite specification directly in julia code by
using the `vl` string macro:

```julia
using VegaLite

spec = vl"""
{
  "$schema": "https://vega.github.io/schema/vega-lite/v2.json",
  "description": "A simple bar chart with embedded data.",
  "data": {
    "values": [
      {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
      {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
      {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
    ]
  },
  "mark": "bar",
  "encoding": {
    "x": {"field": "a", "type": "ordinal"},
    "y": {"field": "b", "type": "quantitative"}
  }
}
"""
```

The resulting `VLSpec` object is indistinguishable from one that is
created via the julia API.

The main benefit of this approach is that one can directly leverage
JSON vega-lite examples and code.

### Loading and saving vega-lite specifications

The `loadspec` and `savespec` function can be used to load and save
vega-lite specifications from disc. The following example loads a
vega-lite specification from a file named `myfigure.vegalite`:

```julia
using VegaLite

spec = loadspec("myfigure.vegalite")
```

To save a `VLSpec` to a file on disc, use the `savespec` function:

```julia
using VegaLite

spec = ... # Aquire a spec from somewhere

savespec("myfigure.vegalite", spec)
```

### [DataVoyager.jl](https://github.com/davidanthoff/DataVoyager.jl)

The [DataVoyager.jl](https://github.com/davidanthoff/DataVoyager.jl)
package provides a graphical UI for data exploration that is based on
vega-lite. One can use that tool to create a figure in the UI, and then
export the corresponding vega-lite specification for use with this package
here.
