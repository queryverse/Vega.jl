# Error Bars & Error Bands

## Error Bars showing Confidence Interval

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot() +
@vlplot(
    mark={
        :point,
        filled=true
    },
    x={
        "mean(yield)",
        scale={zero=false},
        axis={title="Barley Yield"}
    },
    y={
        "variety:o",
        color={value=:black}
    }
) +
@vlplot(:rule, x="ci0(yield)", x2="ci1(yield)", y="variety:o")
```

## Error Bars showing Standard Deviation

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot(
    transform=[
        {
            aggregate=[
                {op=:mean, field=:yield, as=:mean},
                {op=:stdev, field=:yield, as=:stdev}
            ],
            groupby=[:variety]
        },
        {calculate="datum.mean-datum.stdev", as=:lower},
        {calculate="datum.mean+datum.stdev", as=:upper}
    ]
) +
@vlplot(
    mark={
        :point,
        filled=true
    },
    x={
        "mean:q",
        scale={zero=false},
        axis={title="Barley Yield"}
    },
    y="variety:o",
    color={value=:black}
) +
@vlplot(:rule, x="upper:q", x2="lower:q", y="variety:o")
```

## Line Chart with Confidence Interval Band

```@example
using VegaLite, VegaDatasets

dataset("cars") |>
@vlplot() +
@vlplot(
    :area,
    x="year(Year):t",
    y={
        "ci0(Miles_per_Gallon)",
        axis={title="Mean of Miles per Gallon (95% CIs)"}
    },
    y2="ci1(Miles_per_Gallon)",
    opacity={value=0.3}
) +
@vlplot(
    :line,
    x="year(Year)",
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
    x=:Horsepower,
    y=:Miles_per_Gallon
) +
(
    @vlplot(
        transform=[
            {aggregate=[
                {op=:mean, field=:Miles_per_Gallon, as=:mean_MPG},
                {op=:stdev, field=:Miles_per_Gallon, as=:dev_MPG}
                ],
                groupby=[]
            },
            {calculate="datum.mean_MPG - datum.dev_MPG", as=:lower},
            {calculate="datum.mean_MPG + datum.dev_MPG", as=:upper}
        ]) +
    @vlplot(:rule,y={"mean_MPG:q",axis=nothing}) +
    @vlplot(
        :rect,
        y={"lower:q",axis=nothing},
        y2="upper:q",
        opacity={value=0.2}
    )
)
```
