# Error Bars & Error Bands

## Error Bars showing Confidence Interval

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot(y="variety:o") +
@vlplot(
    mark={
        :point,
        filled=true
    },
    x={
        "mean(yield)",
        scale={zero=false},
        title="Barley Yield"
    },
    color={value=:black}
) +
@vlplot(
    mark={
        :errorbar,
        extent=:ci
     },
     x={"yield:q", title="Barley Yield"}
)
```

## Error Bars showing Standard Deviation

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot(
    y="variety:o"
) +
@vlplot(
    mark={
        :point,
        filled=true
    },
    x={
        "mean(yield):q",
        scale={zero=false},
        title="Barley Yield"
    },
    color={value=:black}
) +
@vlplot(
    mark={:rule, extend=:stdev},
    x={"yield:q", title="Barley Yield"}
)
```

## Line Chart with Confidence Interval Band

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot(x="year(Year)") +
@vlplot(
    mark={:errorband, extent=:ci},
    y={
        "Miles_per_Gallon:q",
        title="Mean of Miles per Gallon (95% CIs)"
    }
) +
@vlplot(
    :line,
    y="mean(Miles_per_Gallon)"
)
```

## Scatterplot with Mean and Standard Deviation Overlay

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot() +
@vlplot(
    :point,
    x="Horsepower:q",
    y="Miles_per_Gallon:q"
) +
@vlplot(:rule,y="mean(Miles_per_Gallon):q") +
@vlplot(
    mark={:errorband, extent=:stdev, opacity=0.2},
    y={"Miles_per_Gallon:q", title="Miles per Gallon"}
)
```
