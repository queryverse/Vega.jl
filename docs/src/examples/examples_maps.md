## Choropleth of unemployment rate per county

```@example
using VegaLite, VegaDatasets

us10m = dataset("us-10m").path
unemployment = dataset("unemployment.tsv").path

@vlplot(
    :geoshape,
    width=500, height=300,
    data={
        url=us10m,
        format={
            typ=:topojson,
            feature=:counties
        }
    },
    transform=[{
        lookup=:id,
        from={
            data=unemployment,
            key=:id,
            fields=["rate"]
        }
    }],
    projection={
        typ=:albersUsa
    },
    color="rate:q"
)
```

## One dot per zipcode in the U.S.

```@example
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

VegaLite.MimeWrapper{MIME"image/png"}(dataset("zipcodes").path |> @vlplot(:circle,width=500,height=300,transform=[{calculate="substring(datum.zip_code, 0, 1)", as=:digit}],projection={typ=:albersUsa},longitude="longitude:q",latitude="latitude:q",size={value=1},color="digit:n")) # hide
```

## One dot per airport in the US overlayed on geoshape

```@example
using VegaLite, VegaDatasets

us10m = dataset("us-10m").path
airports = dataset("airports")

@vlplot(width=500, height=300) +
@vlplot(
    mark={
        :geoshape,
        fill=:lightgray,
        stroke=:white
    },
    data={
        url=us10m,
        format={typ=:topojson, feature=:states}
    },
    projection={typ=:albersUsa},
) +
@vlplot(
    :circle,
    data=airports,
    projection={typ=:albersUsa},
    longitude="longitude:q",
    latitude="latitude:q",
    size={value=10},
    color={value=:steelblue}
)
```

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
