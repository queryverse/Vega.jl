## Choropleth of unemployment rate per county

TODO

## One dot per zipcode in the U.S.

TODO convert this to PNG output

```julia
using VegaLite, VegaDatasets

dataset("zipcodes").path |>
@vlplot(
    :circle,
    width=500, height=300,
    transform=[{calculate="substring(datum.zip_code, 0, 1)", as=:digit}],
    projection={typ=:albersUsa},
    longitude="longitude:q",
    latitude="latitude:q",
    size={value=1},
    color="digit:n"
)
```

## One dot per airport in the US overlayed on geoshape

TODO

## Rules (line segments) connecting SEA to every airport reachable via direct flight

TODO

## Three choropleths representing disjoint data from the same table

TODO

## U.S. state capitals overlayed on a map of the U.S

```@example
using VegaLite, VegaDatasets

us10m = dataset("us-10m").path
usstatecapitals = dataset("us-state-capitals").path

p = @vlplot(width=800, height=500, projection={typ=:albersUsa}) +
@vlplot(
    data={
        url=us10m,
        format={
            typ=:topojson,
            feature=:states
        }
    },
    mark={
        :geoshape,
        fill=:lightgray,
        stroke=:white
    }
) +
(
    @vlplot(
        data={url=usstatecapitals},
        enc={
            longitude="lon:q",
            latitude="lat:q"
        }
    ) +
    @vlplot(mark={:circle, color=:orange}) +
    @vlplot(mark={:text, dy=-6}, text="city:n")
)
```

## Line drawn between airports in the U.S. simulating a flight itinerary

TODO

## Income in the U.S. by state, faceted over income brackets

TODO

## London Tube Lines

TODO
