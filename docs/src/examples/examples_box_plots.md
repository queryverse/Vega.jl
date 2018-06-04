# Box Plots

## Box Plot with Min/Max Whiskers

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    transform=[{
        aggregate=[
            {op=:q1, field=:people, as=:lowerBox},
            {op=:q3, field=:people, as=:upperBox},
            {op=:median, field=:people, as=:midBox},
            {op=:min, field=:people, as=:lowerWhisker},
            {op=:max, field=:people, as=:upperWhisker}
        ],
        groupby=[:age]
    }]
) +
@vlplot(
    mark={:rule, style=:boxWhisker},
    y={"lowerWhisker:q", axis={title="population"}},
    y2="lowerBox:q",
    x="age:o"
) +
@vlplot(
    mark={:rule, style=:boxWhisker},
    y="upperBox:q",
    y2="upperWhisker:q",
    x="age:o"
) +
@vlplot(
    mark={:bar, style=:box},
    y="lowerBox:q",
    y2="upperBox:q",
    x="age:o",
    size={value=5}
) +
@vlplot(
    mark={:tick, style=:boxMid},
    y="midBox:q",
    x="age:o",
    color={value=:white},
    size={value=5}
)
```

## Tukey Box Plot (1.5 IQR)

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    transform=[
        {
            aggregate=[
                {op=:q1, field=:people, as=:lowerBox},
                {op=:q3, field=:people, as=:upperBox},
                {op=:median, field=:people, as=:midBox}
            ],
            groupby=[:age]
        },
        {
            calculate="datum.upperBox - datum.lowerBox",
            as=:IQR
        },
        {
            calculate="datum.lowerBox - datum.IQR * 1.5",
            as=:lowerWhisker
        },
        {
            calculate="datum.upperBox + datum.IQR * 1.5",
            as=:upperWhisker
        }
    ]
) +
@vlplot(
    mark={:rule, style=:boxWhisker},
    y={"lowerWhisker:q", axis={title="population"}},
    y2="lowerBox:q",
    x="age:o"
) +
@vlplot(
    mark={:rule, style=:boxWhisker},
    y="upperBox:q",
    y2="upperWhisker:q",
    x="age:o"
) +
@vlplot(
    mark={:bar, style=:box},
    y="lowerBox:q",
    y2="upperBox:q",
    x="age:o",
    size={value=5}
) +
@vlplot(
    mark={:tick, style=:boxMid},
    y="midBox:q",
    x="age:o",
    color={value=:white},
    size={value=5}
)
```
