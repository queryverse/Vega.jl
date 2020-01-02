# Simple Charts

## Simple Bar Chart

```@example
using VegaLite, DataFrames

data = DataFrame(
    a=["A","B","C","D","E","F","G","H","I"],
    b=[28,55,43,91,81,53,19,87,52]
)

data |> @vlplot(:bar, :a, :b)
```

## Simple Heatmap

```@example
using VegaLite, DataFrames

x = [j for i in -5:4, j in -5:4]
y = [i for i in -5:4, j in -5:4]
z = x.^2 .+ y.^2
data = DataFrame(x=vec(x'),y=vec(y'),z=vec(z'))

data |> @vlplot(:rect, "x:o", "y:o", color=:z)
```

## Simple Histogram

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(:bar, x={:IMDB_Rating, bin=true}, y="count()")
```

## Simple Line Chart

```@example
using VegaLite

x = 0:100
y = sin.(x./5)

@vlplot(:line, x=x, y={y, title="sin(x)"})
```

## Simple Scatter Plot

```@example
using VegaLite, VegaDatasets

dataset("iris") |>
@vlplot(:point, x=:petalWidth, y=:petalLength, color=:species)
```

TODO Add interactivity

## Simple Stacked Area Chart

```@example
using VegaLite, VegaDatasets

dataset("unemployment-across-industries") |>
@vlplot(:area, x="date:t", y=:count, color=:series)
```

## Strip Plot

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot(:tick, x=:Horsepower, y="Cylinders:o")
```
