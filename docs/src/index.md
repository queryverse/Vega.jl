
[VegaLite.jl](https://github.com/fredo-dedup/VegaLite.jl) enables the generation of [Vega-Lite](https://vega.github.io/vega-lite/) plots from Julia.

[Vega-Lite](https://vega.github.io/vega-lite/) is a visualization grammar describing mappings from data to graphical properties (e.g. marks, axes, scales). For rendering it uses pre-defined design rules that keep the visualization specification succinct while still leaving user control.

Vega-Lite supports:
- data transformation, sorting, filtering and grouping.
- aggregation, binning, and simple statistical analysis (e.g. mean, std, var, count).
- plots can be faceted, layered and stacked vertically or horizontally.

### Installation

To install the package run `Pkg.add("VegaLite")`.

### Principles

The package is essentially a thin layer translating Julia statements to the [Vega-Lite](https://vega.github.io/vega-lite/) visualization specification format.

One can take any Vega-Lite specification and easily translate it into corresponding julia code. In addition, the package provides various ways to specify figures in a much more concise way. Here is an example of a scatter plot with a legend:

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
