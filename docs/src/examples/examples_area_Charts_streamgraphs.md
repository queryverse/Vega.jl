# Area Charts & Streamgraphs

## Area Chart

```@example
using VegaLite, VegaDatasets

dataset("unemployment-across-industries") |>
@vlplot(
    :area,
    width=300, height=200,
    x={
        "yearmonth(date):t",
        axis={format="%Y"}
    },
    y={
        "sum(count)",
        axis={title="count"}
    }    
)
```

## Area Chart with Overlaying Lines and Point Markers

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    transform=[{filter="datum.symbol==='GOOG'"}],
    mark={
        :area,
        line=true,
        point=true
    },
    x="date:t",
    y=:price
)
```

## Stacked Area Chart

```@example
using VegaLite, VegaDatasets

dataset("unemployment-across-industries") |>
@vlplot(
    :area,
    width=300, hieght=200,
    x={
        "yearmonth(date):t",
        axis={format="%Y"}
    },
    y="sum(count)",
    color={
        :series,
        scale={scheme="category20b"}
    }
)
```

## Normalized Stacked Area Chart

```@example
using VegaLite, VegaDatasets

dataset("unemployment-across-industries") |>
@vlplot(
    :area,
    width=300, height=200,
    x={
        "yearmonth(date)",
        axis={
            domain=false,
            format="%Y"
        }
    },
    y={
        "sum(count)",
        axis=nothing,
        stack=:normalize
    },
    color={
        :series,
        scale={scheme="category20b"}
    }
)
```

## Streamgraph

```@example
using VegaLite, VegaDatasets

dataset("unemployment-across-industries") |>
@vlplot(
    :area,
    width=300, height=200,
    x={
        "yearmonth(date)",
        axis={
            domain=false,
            format="%Y",
            tickSize=0
        }
    },
    y={
        "sum(count)",
        axis=nothing,
        stack=:center
    },
    color={
        :series,
        scale={scheme="category20b"}
    }
)
```

## Horizon Graph

TODO
