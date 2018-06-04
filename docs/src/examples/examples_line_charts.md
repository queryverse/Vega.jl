# Line Charts

## Line Chart

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    :line,
    transform=[
        {filter="datum.symbol=='GOOG'"}
    ],
    x={"date:t", axis={format="%Y"}},
    y=:price
)
```

## Line Chart with Overlaying Point Markers

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    transform=[{filter="datum.symbol==='GOOG'"}],
    mark={
        :line,
        color=:green,
        point={
            color=:red
        }
    },
    x="date:t",
    y=:price
)
```

## Multi Series Line Chart

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    :line,
    x={"date:t", axis={format="%Y"}},
    y=:price,
    color=:symbol
)
```

## Slope Graph

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot(
    :line,
    x={
        "year:o",
        scale={
            rangeStep=50,
            padding=0.5
        }
    },
    y="median(yield)",
    color=:site
)
```

## Step Chart

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    transform=[{filter="datum.symbol==='GOOG'"}],
    mark={
        :line,
        interpolate="step-after"
    },
    x="date:t",
    y=:price
)
```

## Line Chart with Monotone Interpolation

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    transform=[{filter="datum.symbol==='GOOG'"}],
    mark={
        :line,
        interpolate="monotone"
    },
    x="date:t",
    y=:price
)
```

## Connected Scatterplot (Lines with Custom Paths)

```@example
using VegaLite, VegaDatasets

dataset("driving") |>
@vlplot(
    mark={
        :line,
        point=true
    },
    x={
        :miles,
        scale={zero=false}
    },
    y={
        :gas,
        scale={zero=false}
    },
    order="year:t"
)
```

## Line Chart with Varying Size (using the trail mark)

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    :trail,
    x={
        "date:t",
        axis={format="%Y"}
    },
    y=:price,
    size=:price,
    color=:symbol
)
```

## Line Chart with Markers and Invalid Values

```@example
using VegaLite, DataFrames

data = DataFrame(
    x=[1,2,3,4,5,6,7],
    y=[10,30,missing,15,missing,40,20]
)

data |>
@vlplot(
    mark={
        :line,
        point=true
    },
    x=:x,
    y=:y
)
```

## Carbon Dioxide in the Atmosphere

TODO

## Line Charts Showing Ranks Over Time

```@example
using VegaLite, DataFrames

data = DataFrame(
    team=["Man Utd", "Chelsea", "Man City", "Spurs", "Man Utd", "Chelsea",
        "Man City", "Spurs", "Man Utd", "Chelsea", "Man City", "Spurs"],
    matchday=[1,1,1,1,2,2,2,2,3,3,3,3],
    point=[3,1,1,0,6,1,0,3,9,1,0,6]
)

data |>
@vlplot(
    transform=[{
        sort=[{field="point", order="descending"}],
        window=[{
            op="rank",
            as="rank"
        }],
        groupby=["matchday"]
    }],
    mark={
        :line,
        orient="vertical"
    },
    x="matchday:o",
    y="rank:o",
    color={
        :team,
        scale={
            domain=["Man Utd", "Chelsea", "Man City", "Spurs"],
            range=["#cc2613", "#125dc7", "#8bcdfc", "#d1d1d1"]
        }
    }
)
```
