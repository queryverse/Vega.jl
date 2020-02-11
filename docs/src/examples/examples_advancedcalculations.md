# Advanced Calculations

# Calculate Percentage of Total

A bar graph showing what activites consume what percentage of the day.

```@example
using VegaLite, DataFrames

data = DataFrame(
    Activity=["Sleeping","Eating","TV","Work","Exercise"],
    Time=[8,2,4,8,2]
)

data |> 
@vlplot(
    height={step=12},
    :bar,
    transform=[
        {
            window=[{op="sum",field="Time",as="TotalTime"}],
            frame=[nothing,nothing]
        },
        {
            calculate="datum.Time/datum.TotalTime * 100",
            as="PercentOfTotal"
        }
    ],
    x={"PercentOfTotal:q", axis={title="% of total Time"}},
    y={"Activity:n"}
)
```

# Calculate Difference from Average

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    transform=[
        {filter="datum.IMDB_Rating != null"},
        {
            joinaggregate= [{
                op=:mean,
                field=:IMDB_Rating,
                as="AverageRating"
            }]
        },
        {filter="(datum.IMDB_Rating - datum.AverageRating) > 2.5"}
    ]
) + 
@vlplot(
    :bar,
    x={"IMDB_Rating:q",axis={title="IMDB Rating"}},
    y={"Title:o"}
) +
@vlplot(
    mark={
        :rule,
        color="red"
    },
    x={"AverageRating:q", aggregate="average"}
)
```

# Calculate Difference from Annual Average

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    transform=[
        {filter="datum.IMDB_Rating != null"},
        {timeUnit="year",field="Release_Date",as="year"},
        {
            joinaggregate= [{
                op=:mean,
                field=:IMDB_Rating,
                as="AverageYearRating"
            }],
            groupby=["year"]
        },
        {
            filter="(datum.IMDB_Rating - datum.AverageYearRating) > 2.5"
        }
    ]
) + 
@vlplot(
    mark={:bar,clip=true},
    x={"IMDB_Rating:q",axis={title="IMDB Rating"}},
    y={"Title:o"}
) +
@vlplot(
    mark=:tick,
    color={value="red"},
    x="AverageYearRating:q",
    y="Title:o"
)
```


