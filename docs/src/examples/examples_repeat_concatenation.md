## Repeat and layer to show different weather measures

```@example
using VegaLite, VegaDatasets

dataset("weather.csv") |>
@vlplot(repeat={column=[:temp_max,:precipitation,:wind]}) +
(
    @vlplot() +
    @vlplot(
        :line,
        y={field={repeat=:column},aggregate=:mean,typ=:quantitative},
        x="month(date):o",
        detail="year(date):t",
        color=:location,
        opacity={value=0.2}
    ) +
    @vlplot(
        :line,
        y={field={repeat=:column},aggregate=:mean,typ=:quantitative},
        x="month(date):o",
        color=:location
    )
)
```

## Vertically concatenated charts that show precipitation in Seattle

```@example
using VegaLite, VegaDatasets

dataset("weather.csv") |>
@vlplot(transform=[{filter="datum.location === 'Seattle'"}]) +
[
    @vlplot(:bar,x="month(date):o",y="mean(precipitation)");
    @vlplot(:point,x={:temp_min, bin=true}, y={:temp_max, bin=true}, size="count()")
]
```

## Horizontally repeated charts

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot(repeat={column=[:Horsepower, :Miles_per_Gallon, :Acceleration]}) +
@vlplot(:bar,x={field={repeat=:column},bin=true,typ=:quantitative}, y="count()", color=:Origin)
```

## Interactive Scatterplot Matrix

TODO
