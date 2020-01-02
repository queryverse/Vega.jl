# Bar Charts & Histograms

## Simple Bar Chart

```@example
using VegaLite, DataFrames

data = DataFrame(
    a=["A","B","C","D","E","F","G","H","I"],
    b=[28,55,43,91,81,53,19,87,52]
)

data |> @vlplot(:bar, x="a:o", y=:b)
```

## Histogram

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(:bar, x={:IMDB_Rating, bin=true}, y="count()")
```

## Aggregate Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    :bar,
    transform=[{filter="datum.year == 2000"}],
    y="age:o",
    x={"sum(people)", axis={title="population"}}
)
```

## Grouped Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    :bar,
    transform=[
        {filter="datum.year == 2000"},
        {calculate="datum.sex == 2 ? 'Female' : 'Male'", as="gender"}
    ],
    column="age:o",
    y={"sum(people)", axis={title="population", grid=false}},
    x={"gender:n", axis={title=""}},
    color={"gender:n", scale={range=["#EA98D2", "#659CCA"]}},
    spacing=10,
    config={
        view={stroke=:transparent},
        axis={domainWidth=1}
    }
)
```

## Stacked Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("seattle-weather") |>
@vlplot(
    :bar,
    x={"month(date):o", axis={title="Month of the year"}},
    y="count()",
    color={
        :weather,
        scale={
            domain=["sun","fog","drizzle","rain","snow"],
            range=["#e7ba52","#c7c7c7","#aec7e8","#1f77b4","#9467bd"]
        },
        legend={
            title="Weather type"
        }
    }
)
```

## Horizontal Stacked Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("barley") |>
@vlplot(:bar, x="sum(yield)", y=:variety, color=:site)
```

## Normalized Stacked Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    :bar,
    transform=[
        {filter="datum.year == 2000"},
        {calculate="datum.sex==2 ? 'Female' : 'Male'",as="gender"}
    ],
    y={
        "sum(people)",
        axis={title="population"},
        stack=:normalize
    },
    x="age:o",
    color={
        "gender:n",
        scale={range=["#EA98D2", "#659CCA"]}
    },
    width={step=17}    
)
```

## Gantt Chart (Ranged Bar Marks)

```@example
using VegaLite

@vlplot(
    :bar,
    data={
        values=[
            {task="A",start=1,stop=3},
            {task="B",start=3,stop=8},
            {task="C",start=8,stop=10}
        ]
    },
    y="task:o",
    x="start:q",
    x2="stop:q"
)
```

## A bar chart encoding color names in the data

```@example
using VegaLite

@vlplot(
    :bar,
    data={
        values=[
            {color="red",b=28},
            {color="green",b=55},
            {color="blue",b=43}
        ]
    },
    x="color:n",
    y="b:q",
    color={"color:n",scale=nothing}
)
```

## Layered Bar Chart

```@example
using VegaLite, VegaDatasets

dataset("population") |>
@vlplot(
    :bar,
    transform=[
        {filter="datum.year==2000"},
        {calculate="datum.sex==2 ? 'Female' : 'Male'",as="gender"}
    ],
    x="age:o",
    y={"sum(people)", axis={title="population"}, stack=nothing},
    color={"gender:n", scale={range=["#e377c2", "#1f77b4"]}},
    opacity={value=0.7},
    width={step=17}
)
```

## Diverging Stacked Bar Chart

```@example
using VegaLite, DataFrames

data = DataFrame(
    question=["Question $(div(i,5)+1)" for i in 0:39],
    type=repeat(["Strongly disagree", "Disagree", "Neither agree nor disagree",
        "Agree", "Strongly agree"],outer=8),
    value=[24, 294, 594, 1927, 376, 2, 2, 0, 7, 11, 2, 0, 2, 4, 2, 0, 2, 1, 7,
        6, 0, 1, 3, 16, 4, 1, 1, 2, 9, 3, 0, 0, 1, 4, 0, 0, 0, 0, 0, 2],
    percentage=[0.7, 9.1, 18.5, 59.9, 11.7, 18.2, 18.2, 0, 63.6, 0, 20, 0, 20,
        40, 20, 0, 12.5, 6.3, 43.8, 37.5, 0, 4.2, 12.5, 66.7, 16.7, 6.3, 6.3,
        12.5, 56.3, 18.8, 0, 0, 20, 80, 0, 0, 0, 0, 0, 100],
    percentage_start=[-19.1, -18.4, -9.2, 9.2, 69.2, -36.4, -18.2, 0, 0, 63.6,
        -30, -10, -10, 10, 50, -15.6, -15.6, -3.1, 3.1, 46.9, -10.4, -10.4,
        -6.3, 6.3, 72.9, -18.8, -12.5, -6.3, 6.3, 62.5, -10, -10, -10, 10, 90,
        0, 0, 0, 0, 0],
    percentage_end=[-18.4, -9.2, 9.2, 69.2, 80.9, -18.2, 0, 0, 63.6, 63.6, -10,
        -10, 10, 50, 70, -15.6, -3.1, 3.1, 46.9, 84.4, -10.4, -6.3, 6.3, 72.9,
        89.6, -12.5, -6.3, 6.3, 62.5, 81.3, -10, -10, 10, 90, 90, 0, 0, 0, 0, 100]
)

data |> @vlplot(
    :bar,
    x={:percentage_start, axis={title="Percentage"}},
    x2=:percentage_end,
    y={
        :question, axis={
            title="Question",
            offset=5,
            ticks=false,
            minExtent=60,
            domain=false
        }
    },
    color={
        :typ,
        legend={title="Response"},
        scale={
            domain=[
                "Strongly disagree",
                "Disagree",
                "Neither agree nor disagree",
                "Agree",
                "Strongly agree"
            ],
            range=["#c30d24", "#f3a583", "#cccccc", "#94c6da", "#1770ab"],
            type=:ordinal
        }
    }
)
```

## Simple Bar Chart with Labels

```@example
using VegaLite

@vlplot(
    data={
        values=[
            {a="A",b=28},
            {a="B",b=55},
            {a="C",b=43}
        ]
    },
    y="a:o",
    x="b:q"
) +
@vlplot(:bar) +
@vlplot(
    mark={
        :text,
        align=:left,
        baseline=:middle,
        dx=3
    },
    text="b:q"
)
```

## Isotype Dot Plot

```@example
using VegaLite, DataFrames

df=DataFrame(
    country=["Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States"],
    animal=["cattle","cattle","cattle","pigs","pigs","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","cattle","cattle","cattle","cattle","cattle","cattle","cattle","cattle","cattle","pigs","pigs","pigs","pigs","pigs","pigs","sheep","sheep","sheep","sheep","sheep","sheep","sheep"],
    col=[3,2,1,2,1,10,9,8,7,6,5,4,3,2,1,9,8,7,6,5,4,3,2,1,6,5,4,3,2,1,7,6,5,4,3,2,1]
)
personSVGPath="M1.7 -1.7h-0.8c0.3 -0.2 0.6 -0.5 0.6 -0.9c0 -0.6 -0.4 -1 -1 -1c-0.6 0 -1 0.4 -1 1c0 0.4 0.2 0.7 0.6 0.9h-0.8c-0.4 0 -0.7 0.3 -0.7 0.6v1.9c0 0.3 0.3 0.6 0.6 0.6h0.2c0 0 0 0.1 0 0.1v1.9c0 0.3 0.2 0.6 0.3 0.6h1.3c0.2 0 0.3 -0.3 0.3 -0.6v-1.8c0 0 0 -0.1 0 -0.1h0.2c0.3 0 0.6 -0.3 0.6 -0.6v-2c0.2 -0.3 -0.1 -0.6 -0.4 -0.6z"
cattleSVGPath="M4 -2c0 0 0.9 -0.7 1.1 -0.8c0.1 -0.1 -0.1 0.5 -0.3 0.7c-0.2 0.2 1.1 1.1 1.1 1.2c0 0.2 -0.2 0.8 -0.4 0.7c-0.1 0 -0.8 -0.3 -1.3 -0.2c-0.5 0.1 -1.3 1.6 -1.5 2c-0.3 0.4 -0.6 0.4 -0.6 0.4c0 0.1 0.3 1.7 0.4 1.8c0.1 0.1 -0.4 0.1 -0.5 0c0 0 -0.6 -1.9 -0.6 -1.9c-0.1 0 -0.3 -0.1 -0.3 -0.1c0 0.1 -0.5 1.4 -0.4 1.6c0.1 0.2 0.1 0.3 0.1 0.3c0 0 -0.4 0 -0.4 0c0 0 -0.2 -0.1 -0.1 -0.3c0 -0.2 0.3 -1.7 0.3 -1.7c0 0 -2.8 -0.9 -2.9 -0.8c-0.2 0.1 -0.4 0.6 -0.4 1c0 0.4 0.5 1.9 0.5 1.9l-0.5 0l-0.6 -2l0 -0.6c0 0 -1 0.8 -1 1c0 0.2 -0.2 1.3 -0.2 1.3c0 0 0.3 0.3 0.2 0.3c0 0 -0.5 0 -0.5 0c0 0 -0.2 -0.2 -0.1 -0.4c0 -0.1 0.2 -1.6 0.2 -1.6c0 0 0.5 -0.4 0.5 -0.5c0 -0.1 0 -2.7 -0.2 -2.7c-0.1 0 -0.4 2 -0.4 2c0 0 0 0.2 -0.2 0.5c-0.1 0.4 -0.2 1.1 -0.2 1.1c0 0 -0.2 -0.1 -0.2 -0.2c0 -0.1 -0.1 -0.7 0 -0.7c0.1 -0.1 0.3 -0.8 0.4 -1.4c0 -0.6 0.2 -1.3 0.4 -1.5c0.1 -0.2 0.6 -0.4 0.6 -0.4z"
pigsSVGPath="M1.2 -2c0 0 0.7 0 1.2 0.5c0.5 0.5 0.4 0.6 0.5 0.6c0.1 0 0.7 0 0.8 0.1c0.1 0 0.2 0.2 0.2 0.2c0 0 -0.6 0.2 -0.6 0.3c0 0.1 0.4 0.9 0.6 0.9c0.1 0 0.6 0 0.6 0.1c0 0.1 0 0.7 -0.1 0.7c-0.1 0 -1.2 0.4 -1.5 0.5c-0.3 0.1 -1.1 0.5 -1.1 0.7c-0.1 0.2 0.4 1.2 0.4 1.2l-0.4 0c0 0 -0.4 -0.8 -0.4 -0.9c0 -0.1 -0.1 -0.3 -0.1 -0.3l-0.2 0l-0.5 1.3l-0.4 0c0 0 -0.1 -0.4 0 -0.6c0.1 -0.1 0.3 -0.6 0.3 -0.7c0 0 -0.8 0 -1.5 -0.1c-0.7 -0.1 -1.2 -0.3 -1.2 -0.2c0 0.1 -0.4 0.6 -0.5 0.6c0 0 0.3 0.9 0.3 0.9l-0.4 0c0 0 -0.4 -0.5 -0.4 -0.6c0 -0.1 -0.2 -0.6 -0.2 -0.5c0 0 -0.4 0.4 -0.6 0.4c-0.2 0.1 -0.4 0.1 -0.4 0.1c0 0 -0.1 0.6 -0.1 0.6l-0.5 0l0 -1c0 0 0.5 -0.4 0.5 -0.5c0 -0.1 -0.7 -1.2 -0.6 -1.4c0.1 -0.1 0.1 -1.1 0.1 -1.1c0 0 -0.2 0.1 -0.2 0.1c0 0 0 0.9 0 1c0 0.1 -0.2 0.3 -0.3 0.3c-0.1 0 0 -0.5 0 -0.9c0 -0.4 0 -0.4 0.2 -0.6c0.2 -0.2 0.6 -0.3 0.8 -0.8c0.3 -0.5 1 -0.6 1 -0.6z"
sheepSVGPath="M-4.1 -0.5c0.2 0 0.2 0.2 0.5 0.2c0.3 0 0.3 -0.2 0.5 -0.2c0.2 0 0.2 0.2 0.4 0.2c0.2 0 0.2 -0.2 0.5 -0.2c0.2 0 0.2 0.2 0.4 0.2c0.2 0 0.2 -0.2 0.4 -0.2c0.1 0 0.2 0.2 0.4 0.1c0.2 0 0.2 -0.2 0.4 -0.3c0.1 0 0.1 -0.1 0.4 0c0.3 0 0.3 -0.4 0.6 -0.4c0.3 0 0.6 -0.3 0.7 -0.2c0.1 0.1 1.4 1 1.3 1.4c-0.1 0.4 -0.3 0.3 -0.4 0.3c-0.1 0 -0.5 -0.4 -0.7 -0.2c-0.3 0.2 -0.1 0.4 -0.2 0.6c-0.1 0.1 -0.2 0.2 -0.3 0.4c0 0.2 0.1 0.3 0 0.5c-0.1 0.2 -0.3 0.2 -0.3 0.5c0 0.3 -0.2 0.3 -0.3 0.6c-0.1 0.2 0 0.3 -0.1 0.5c-0.1 0.2 -0.1 0.2 -0.2 0.3c-0.1 0.1 0.3 1.1 0.3 1.1l-0.3 0c0 0 -0.3 -0.9 -0.3 -1c0 -0.1 -0.1 -0.2 -0.3 -0.2c-0.2 0 -0.3 0.1 -0.4 0.4c0 0.3 -0.2 0.8 -0.2 0.8l-0.3 0l0.3 -1c0 0 0.1 -0.6 -0.2 -0.5c-0.3 0.1 -0.2 -0.1 -0.4 -0.1c-0.2 -0.1 -0.3 0.1 -0.4 0c-0.2 -0.1 -0.3 0.1 -0.5 0c-0.2 -0.1 -0.1 0 -0.3 0.3c-0.2 0.3 -0.4 0.3 -0.4 0.3l0.2 1.1l-0.3 0l-0.2 -1.1c0 0 -0.4 -0.6 -0.5 -0.4c-0.1 0.3 -0.1 0.4 -0.3 0.4c-0.1 -0.1 -0.2 1.1 -0.2 1.1l-0.3 0l0.2 -1.1c0 0 -0.3 -0.1 -0.3 -0.5c0 -0.3 0.1 -0.5 0.1 -0.7c0.1 -0.2 -0.1 -1 -0.2 -1.1c-0.1 -0.2 -0.2 -0.8 -0.2 -0.8c0 0 -0.1 -0.5 0.4 -0.8z"

df |> @vlplot(
    config={view={stroke=nothing}},
    height=200,
    width=800,
    mark={:point, filled=true},
    x={"col:o", axis=nothing},
    y={"animal:o", axis=nothing},
    row={"country:n", header={title=nothing}},
    shape={
        "animal:n",
        scale={
            domain=[ "person", "cattle", "pigs", "sheep" ],
            range=[ personSVGPath, cattleSVGPath, pigsSVGPath, sheepSVGPath ]
        },
        legend=nothing
    },
    color={
        "animal:n",
        legend=nothing,
        scale={
            domain=[ "person", "cattle", "pigs", "sheep" ],
            range=[
                "rgb(162,160,152)",
                "rgb(194,81,64)",
                "rgb(93,93,93)",
                "rgb(91,131,149)"
            ]
        }
    },
    opacity={ value=1 },
    size={ value=200 }
)
```

## Isotype Dot Plot with Emoji

```@example
using VegaLite, DataFrames

df=DataFrame(
    country=["Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","Great,Britain","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States","United,States"],
    animal=["cattle","cattle","cattle","pigs","pigs","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","sheep","cattle","cattle","cattle","cattle","cattle","cattle","cattle","cattle","cattle","pigs","pigs","pigs","pigs","pigs","pigs","sheep","sheep","sheep","sheep","sheep","sheep","sheep"],
    col=[3,2,1,2,1,10,9,8,7,6,5,4,3,2,1,9,8,7,6,5,4,3,2,1,6,5,4,3,2,1,7,6,5,4,3,2,1]
)
personSVGPath="M1.7 -1.7h-0.8c0.3 -0.2 0.6 -0.5 0.6 -0.9c0 -0.6 -0.4 -1 -1 -1c-0.6 0 -1 0.4 -1 1c0 0.4 0.2 0.7 0.6 0.9h-0.8c-0.4 0 -0.7 0.3 -0.7 0.6v1.9c0 0.3 0.3 0.6 0.6 0.6h0.2c0 0 0 0.1 0 0.1v1.9c0 0.3 0.2 0.6 0.3 0.6h1.3c0.2 0 0.3 -0.3 0.3 -0.6v-1.8c0 0 0 -0.1 0 -0.1h0.2c0.3 0 0.6 -0.3 0.6 -0.6v-2c0.2 -0.3 -0.1 -0.6 -0.4 -0.6z"
cattleSVGPath="M4 -2c0 0 0.9 -0.7 1.1 -0.8c0.1 -0.1 -0.1 0.5 -0.3 0.7c-0.2 0.2 1.1 1.1 1.1 1.2c0 0.2 -0.2 0.8 -0.4 0.7c-0.1 0 -0.8 -0.3 -1.3 -0.2c-0.5 0.1 -1.3 1.6 -1.5 2c-0.3 0.4 -0.6 0.4 -0.6 0.4c0 0.1 0.3 1.7 0.4 1.8c0.1 0.1 -0.4 0.1 -0.5 0c0 0 -0.6 -1.9 -0.6 -1.9c-0.1 0 -0.3 -0.1 -0.3 -0.1c0 0.1 -0.5 1.4 -0.4 1.6c0.1 0.2 0.1 0.3 0.1 0.3c0 0 -0.4 0 -0.4 0c0 0 -0.2 -0.1 -0.1 -0.3c0 -0.2 0.3 -1.7 0.3 -1.7c0 0 -2.8 -0.9 -2.9 -0.8c-0.2 0.1 -0.4 0.6 -0.4 1c0 0.4 0.5 1.9 0.5 1.9l-0.5 0l-0.6 -2l0 -0.6c0 0 -1 0.8 -1 1c0 0.2 -0.2 1.3 -0.2 1.3c0 0 0.3 0.3 0.2 0.3c0 0 -0.5 0 -0.5 0c0 0 -0.2 -0.2 -0.1 -0.4c0 -0.1 0.2 -1.6 0.2 -1.6c0 0 0.5 -0.4 0.5 -0.5c0 -0.1 0 -2.7 -0.2 -2.7c-0.1 0 -0.4 2 -0.4 2c0 0 0 0.2 -0.2 0.5c-0.1 0.4 -0.2 1.1 -0.2 1.1c0 0 -0.2 -0.1 -0.2 -0.2c0 -0.1 -0.1 -0.7 0 -0.7c0.1 -0.1 0.3 -0.8 0.4 -1.4c0 -0.6 0.2 -1.3 0.4 -1.5c0.1 -0.2 0.6 -0.4 0.6 -0.4z"
pigsSVGPath="M1.2 -2c0 0 0.7 0 1.2 0.5c0.5 0.5 0.4 0.6 0.5 0.6c0.1 0 0.7 0 0.8 0.1c0.1 0 0.2 0.2 0.2 0.2c0 0 -0.6 0.2 -0.6 0.3c0 0.1 0.4 0.9 0.6 0.9c0.1 0 0.6 0 0.6 0.1c0 0.1 0 0.7 -0.1 0.7c-0.1 0 -1.2 0.4 -1.5 0.5c-0.3 0.1 -1.1 0.5 -1.1 0.7c-0.1 0.2 0.4 1.2 0.4 1.2l-0.4 0c0 0 -0.4 -0.8 -0.4 -0.9c0 -0.1 -0.1 -0.3 -0.1 -0.3l-0.2 0l-0.5 1.3l-0.4 0c0 0 -0.1 -0.4 0 -0.6c0.1 -0.1 0.3 -0.6 0.3 -0.7c0 0 -0.8 0 -1.5 -0.1c-0.7 -0.1 -1.2 -0.3 -1.2 -0.2c0 0.1 -0.4 0.6 -0.5 0.6c0 0 0.3 0.9 0.3 0.9l-0.4 0c0 0 -0.4 -0.5 -0.4 -0.6c0 -0.1 -0.2 -0.6 -0.2 -0.5c0 0 -0.4 0.4 -0.6 0.4c-0.2 0.1 -0.4 0.1 -0.4 0.1c0 0 -0.1 0.6 -0.1 0.6l-0.5 0l0 -1c0 0 0.5 -0.4 0.5 -0.5c0 -0.1 -0.7 -1.2 -0.6 -1.4c0.1 -0.1 0.1 -1.1 0.1 -1.1c0 0 -0.2 0.1 -0.2 0.1c0 0 0 0.9 0 1c0 0.1 -0.2 0.3 -0.3 0.3c-0.1 0 0 -0.5 0 -0.9c0 -0.4 0 -0.4 0.2 -0.6c0.2 -0.2 0.6 -0.3 0.8 -0.8c0.3 -0.5 1 -0.6 1 -0.6z"
sheepSVGPath="M-4.1 -0.5c0.2 0 0.2 0.2 0.5 0.2c0.3 0 0.3 -0.2 0.5 -0.2c0.2 0 0.2 0.2 0.4 0.2c0.2 0 0.2 -0.2 0.5 -0.2c0.2 0 0.2 0.2 0.4 0.2c0.2 0 0.2 -0.2 0.4 -0.2c0.1 0 0.2 0.2 0.4 0.1c0.2 0 0.2 -0.2 0.4 -0.3c0.1 0 0.1 -0.1 0.4 0c0.3 0 0.3 -0.4 0.6 -0.4c0.3 0 0.6 -0.3 0.7 -0.2c0.1 0.1 1.4 1 1.3 1.4c-0.1 0.4 -0.3 0.3 -0.4 0.3c-0.1 0 -0.5 -0.4 -0.7 -0.2c-0.3 0.2 -0.1 0.4 -0.2 0.6c-0.1 0.1 -0.2 0.2 -0.3 0.4c0 0.2 0.1 0.3 0 0.5c-0.1 0.2 -0.3 0.2 -0.3 0.5c0 0.3 -0.2 0.3 -0.3 0.6c-0.1 0.2 0 0.3 -0.1 0.5c-0.1 0.2 -0.1 0.2 -0.2 0.3c-0.1 0.1 0.3 1.1 0.3 1.1l-0.3 0c0 0 -0.3 -0.9 -0.3 -1c0 -0.1 -0.1 -0.2 -0.3 -0.2c-0.2 0 -0.3 0.1 -0.4 0.4c0 0.3 -0.2 0.8 -0.2 0.8l-0.3 0l0.3 -1c0 0 0.1 -0.6 -0.2 -0.5c-0.3 0.1 -0.2 -0.1 -0.4 -0.1c-0.2 -0.1 -0.3 0.1 -0.4 0c-0.2 -0.1 -0.3 0.1 -0.5 0c-0.2 -0.1 -0.1 0 -0.3 0.3c-0.2 0.3 -0.4 0.3 -0.4 0.3l0.2 1.1l-0.3 0l-0.2 -1.1c0 0 -0.4 -0.6 -0.5 -0.4c-0.1 0.3 -0.1 0.4 -0.3 0.4c-0.1 -0.1 -0.2 1.1 -0.2 1.1l-0.3 0l0.2 -1.1c0 0 -0.3 -0.1 -0.3 -0.5c0 -0.3 0.1 -0.5 0.1 -0.7c0.1 -0.2 -0.1 -1 -0.2 -1.1c-0.1 -0.2 -0.2 -0.8 -0.2 -0.8c0 0 -0.1 -0.5 0.4 -0.8z"

df |> @vlplot(
    config={view={stroke=nothing}},
    height=200,
    width=800,
    transform= [
        {
            calculate="{'cattle': '🐄', 'pigs': '🐖', 'sheep': '🐏'}[datum.animal]",
            as=:emoji
        },
        {window=[{op=:rank, as=:rank}], groupby=[:country, :animal]}
    ],
    mark={:text, baseline=:middle},
    x={"rank:o", axis=nothing},
    y={"animal:n", axis=nothing, sort=nothing},
    row={"country:n", header={title=nothing}},
    text="emoji:n",
    size={ value=65 }
)
```



