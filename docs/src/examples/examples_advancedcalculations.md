# Advanced Calculations

# Calculate Percentage of Total

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

A bar graph showing what activites consume what percentage of the day.

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

Bar graph showing the best films for the year they were produced, where best is defined by at least 2.5 points above average for that year. The red point shows the average rating for a film in that year, and the bar is the rating that the film recieved.

# Calculate Residuals

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    transform=[
        {filter="datum.IMDB_Rating != null"},
        {filter={timeUnit="year",field="Release_Date",range=[1900,2019]}},
        {
            joinaggregate=[{
                op="mean",
                field="IMDB_Rating",
                as="AverageRating"
            }]
        },
        {
            calculate="datum.IMDB_Rating - datum.AverageRating",
            as="RatingDelta"
        }
    ],
    :point,
    x="Release_Date:t",
    y={"RatingDelta:q", axis={title="Rating Delta"}},
    color={"RatingDelta:q",scale={domainMid=0},title="Rating Delta"}
)
```

A dot plot showing each movie in the database, and the difference from the average movie rating. The display is sorted by year to visualize everything in sequential order. The graph is for all Movies before 2019.


