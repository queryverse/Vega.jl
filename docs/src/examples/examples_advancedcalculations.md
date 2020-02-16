# Advanced Calculations

## Calculate Percentage of Total

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

## Calculate Difference from Average

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

## Calculate Difference from Annual Average

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

## Calculate Residuals

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

## Line Charts Showing Ranks Over Time

```@example
using VegaLite, DataFrames

data = DataFrame(
    team=["Germany", "Mexico", "South Korea", "Sweden", "Germany", "Mexico",
        "South Korea", "Sweden", "Germany", "Mexico", "South Korea", "Sweden"],
    matchday=[1,1,1,1,2,2,2,2,3,3,3,3],
    point=[0,3,0,3,3,6,0,3,3,6,3,6],
    diff=[-1,1,-1,1,0,2,-2,0,-2,-1,0,3]
)

data |>
@vlplot(
    title={text="World Cup 2018: Group F Rankings"},
    transform=[{
        sort=[
            {field="point", order="descending"},
            {field="diff", order="descending"}
        ],
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
            domain=["Germany", "Mexico", "South Korea", "Sweden"],
            range=["black", "#127153", "#C91A3C", "#0C71AB"]
        }
    }
)
```

## Waterfall Chart of Monthly Profit and Loss

```@example
using VegaLite, DataFrames

data = DataFrame(
    label=["Begin", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "End"],
    amount=[4000,1707,-1425,-1030,1812,-1067,-1481,1228,1176,1146,1205,-1388,1492,0]
)

data |>
@vlplot(
    width=800,
    height=450,
    transform=[
        {window=[{op="sum",field="amount",as="sum"}]},
        {window=[{op="lead",field="label",as="lead"}]},
        {
            calculate="datum.lead === null ? datum.label : datum.lead",
            as="lead"
        },
        {
            calculate="datum.label === 'End' ? 0 : datum.sum - datum.amount",
            as="previous_sum"
        },
        {
            calculate="datum.label === 'End' ? datum.sum : datum.amount",
            as="amount"
        },
        {
            calculate="(datum.label !== 'Begin' && datum.label !== 'End' && datum.amount > 0 ? '+' : '') + datum.amount",
            as="text_amount"
        },
        {
            calculate="(datum.sum + datum.previous_sum) / 2",
            as="center"
        },
        {
            calculate="datum.sum < datum.previous_sum ? datum.sum : ''",
            as="sum_dec"
        },
        {
            calculate="datum.sum > datum.previous_sum ? datum.sum : ''",
            as="sum_inc"
        }
    ],
    x={"label:o",sort=nothing,axis={labelAngle=0,title="Months"}},
    config={
        text={
            fontWeight="bold",
            color="#404040"
        }
    }
) + 
@vlplot(
    mark={:bar,size=45},
    y={"previous_sum:q",title="Amount"},
    y2=:sum,
    color={
        condition=[
            {test="datum.label === 'Begin' || datum.label === 'End'",value="#f7e0b6"},
            {test="datum.sum < datum.previous_sum",value="#f78a64"}
        ],
        value="#93c4aa"
    }
) +
@vlplot(
    mark={
        :rule,
        color="#404040",
        opacity=1,
        strokeWidth=2,
        xOffset=-22.5,
        x2Offset=22.5
    },
    x2=:lead,
    y="sum:q"
) +
@vlplot(
    mark={
        :text,
        dy=-4,
        baseline="bottom"
    },
    y="sum_inc:q",
    text="sum_inc:n"
) +
@vlplot(
    mark={
        :text,
        dy=4,
        baseline="top"
    },
    y="sum_dec:q",
    text="sum_dec:n"
) +
@vlplot(
    mark={
        :text,
        fontWeight="bold",
        baseline="middle"
    },
    y="center:q",
    text="text_amount:n",
    color={
        condition=[
            {test="datum.label === 'Begin' || datum.label === 'End'",value="#725a30"}
        ],
        value="white"
    }
)
```

## Filtering Top-K Items

```@example
using VegaLite, DataFrames

data = DataFrame(
    student=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V"],
    score=[100,56,88,65,45,23,66,67,13,12,50,78,66,30,97,75,24,42,76,78,21,46]
)

data |>
@vlplot(
    transform=[
        {
            window=[{ op="rank", as="rank" }],
            sort=[{ field="score", order="descending" }]
        },
        {filter="datum.rank <= 5"}
    ],
    mark=:bar,
    x="score:q",
    y={
        "student:n",
        sort={field="score",op="average",order="descending"}
    }
)
```

Here we use window transform to derive the total number of students along with the rank of the current student to determine the top K students and display their score.

## Top-K Plot with "Others"

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    title="Top Directors by Average Worldwide Gross",
    transform=[
        {
            aggregate=[{op="mean",field="Worldwide_Gross",as="aggregate_gross"}],
            groupby=["Director"]
        },
        {
            window=[{op="row_number", as="rank"}],
            sort=[{field="aggregate_gross",order="descending"}]
        },
        {
            calculate="datum.rank < 10 ? datum.Director : 'All Others'", as="ranked_director"
        }
    ],
    :bar,
    x={aggregate="mean","aggregate_gross:q",title=nothing},
    y={
        sort={op="mean",field="aggregate_gross",order="descending"},
        "ranked_director:o",
        title=nothing
    }
)
```

Top-K plot with \"others\" by Trevor Manz, adapted from https://observablehq.com/@manzt/top-k-plot-with-others-vega-lite-example.

## Using the lookup transform to combine data

```@example
using VegaLite, VegaDatasets, DataFrames, CSV

lookup_people_file=replace(joinpath(dirname(pathof(VegaDatasets)),"..","data","data","lookup_people.csv"),"\\" => "/")
lookup_people=CSV.read(lookup_people_file)

dataset("lookup_groups") |>
@vlplot(
    transform=[
        {
            lookup="person",
            from={
                data=lookup_people,
                key="name",
                fields=["age","height"]
            }
        }
    ],
    :bar,
    x="group:o",
    y={"age:q",aggregate="mean"}
)
```

## Cumulative Frequency Distribution

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    :area,
    transform=[{
        sort=[{field=:IMDB_Rating}],
        window=[{field=:count,op="count",as="cumulative_count"}],
        frame=[nothing,0]
    }],
    x="IMDB_Rating:q",
    y="cumulative_count:q"
)
```

## Layered Histogram and Cumulative Histogram

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    transform=[
        {bin=true,field=:IMDB_Rating,as="bin_IMDB_Rating"},
        {
            aggregate=[{op=:count,as="count"}],
            groupby=["bin_IMDB_Rating", "bin_IMDB_Rating_end"]
        },
        {filter="datum.bin_IMDB_Rating !== null"},
        {
            sort=[{field=:bin_IMDB_Rating}],
            window=[{field=:count,op="sum",as="cumulative_count"}],
            frame=[nothing,0]
        }
    ],
    x={"bin_IMDB_Rating:q",scale={zero=false},title="IMDB Rating"},
    x2=:bin_IMDB_Rating_end
) +
@vlplot(
    :bar,
    y="cumulative_count:q"
) +
@vlplot(
    mark={:bar,color=:yellow,opacity=0.5},
    y="count:q"
)
```

## Parallel Coordinate Plot

```@example
using VegaLite, VegaDatasets

dataset("iris") |>
@vlplot(
    width=600,
    height=300,
    config={
        axisX={domain=false, labelAngle=0, tickColor="#ccc", "title"=nothing},
        view={stroke=nothing},
        style={
            label={baseline="middle", align="right", dx=-5},
            tick={orient="horizontal"}
        }
    },
    transform=[
        { window=[{op="count", as="index" }] },
        {fold=["petalLength", "petalWidth", "sepalLength", "sepalWidth"]},
        {
            joinaggregate=[
                {op="min",field="value",as="min"},
                {op="max",field="value",as="max"}
            ],
            groupby=["key"]
        },
        {
            calculate="(datum.value - datum.min) / (datum.max-datum.min)",
            as="norm_val"
        },
        {
            calculate="(datum.min + datum.max) / 2",
            as="mid"
        },
        {
            calculate="'petalLength: '+datum.petalLength+', '+'petalWidth: '+datum.petalWidth+', sepalLength: '+datum.sepalLength+', '+'sepalWidth: '+datum.sepalWidth",
            as="tt"
        } #How to add a line break?
    ]
) +
@vlplot(
    mark={:rule,color="#ccc"},
    detail={aggregate="count",type="quantitative"},
    x="key:n"
) +
@vlplot(
    mark=:line,
    color={field="species",type="nominal"},
    detail={field="index",type="nominal"},
    opacity={value=0.3},
    x="key:n",
    y={"norm_val:q",axis=nothing},
    tooltip={"tt:n"}
)  +
@vlplot(
    mark={:text,style="label"},
    text={aggregate="max",field="max",type="quantitative"},
    x="key:n",
    y={value=0}
)  +
@vlplot(
    mark={:tick,style="tick",size=8,color="#ccc"},
    x="key:n",
    y={value=0}
)  +
@vlplot(
    mark={:text,style="label"},
    text={aggregate="min",field="mid",type="quantitative"},
    x="key:n",
    y={value=150}
)  +
@vlplot(
    mark={:tick,style="tick",size=8,color="#ccc"},
    x="key:n",
    y={value=150}
)  +
@vlplot(
    mark={:text,style="label"},
    text={aggregate="min",field="min",type="quantitative"},
    x="key:n",
    y={value=300}
)  +
@vlplot(
    mark={:tick,style="tick",size=8,color="#ccc"},
    x="key:n",
    y={value=300}
)
```

Though Vega-Lite supports only one scale per axes, one can create a parallel coordinate plot by folding variables, using `joinaggregate` to normalize their values and using ticks and rules to manually create axes.

## Bar Chart Showing Argmax Value

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
    mark=:bar,
    x={aggregate={argmax="US_Gross"},"Production_Budget:q"},
    y={"Major_Genre:n"}
)
```

The production budget of the movie that has the highest US Gross in each major genre.

## Layering Averages over Raw Values

```@example
using VegaLite, VegaDatasets

dataset("stocks") |>
@vlplot(
    transform=[{filter="datum.symbol==='GOOG'"}]
) +
@vlplot(
    mark={:point,opacity=0.3},
    x={timeUnit="year","date:t"},
    y="price:q"
) +
@vlplot(
    mark=:line,
    x={timeUnit="year","date:t"},
    y={aggregate="mean","price:q"}
)
```

Plot showing average data with raw values in the background.

## Layering Rolling Averages over Raw Values

```@example
using VegaLite, VegaDatasets

dataset("seattle-weather") |>
@vlplot(
    width=400,
    height=300,
    transform=[{
        frame=[-15,15],
        window=[{field="temp_max",op="mean",as="rolling_mean"}]
    }]
) +
@vlplot(
    mark={:point,opacity=0.3},
    x={"date:t",title="Date"},
    y={"temp_max:q",title="Max Temperature"}
) +
@vlplot(
    mark={:line,size=3,color="red"},
    x={"date:t",title="Date"},
    y={"rolling_mean:q"}
)
```

Plot showing a 30 day rolling average with raw values in the background.

## Line Chart to Show Benchmarking Results

```@example
using VegaLite, DataFrames

data=DataFrame(
    falcon= [16.81999969482422,19.759998321533203,16.079999923706055,19.579999923706055,16.420000076293945,16.200000762939453,16.020000457763672,15.9399995803833,16.280000686645508,16.119998931884766,16.15999984741211,16.119998931884766,16.139999389648438,16.100000381469727,16.200000762939453,16.260000228881836,19.35999870300293,19.700000762939453,15.9399995803833,19.139999389648438,16.200000762939453,16.119998931884766,19.520000457763672,19.700000762939453,16.200000762939453,20.979999542236328,16.299999237060547,16.420000076293945,16.81999969482422,16.5,16.560001373291016,16.18000030517578,16.079999923706055,16.239999771118164,16.040000915527344,16.299999237060547,19.399999618530273,15.699999809265137,16.239999771118164,15.920000076293945,16.259998321533203,16.219999313354492,16.520000457763672,16.459999084472656,16.360000610351562,15.719999313354492,16.060001373291016,15.960000991821289,16.479999542236328,16.600000381469727,16.240001678466797,16.940000534057617,16.220001220703125,15.959999084472656,15.899999618530273,16.479999542236328,16.31999969482422,15.75999927520752,15.999998092651367,16.18000030517578,16.219999313354492,15.800000190734863,16.139999389648438,16.299999237060547,16.360000610351562,16.260000228881836,15.959999084472656,15.9399995803833,16.53999900817871,16.139999389648438,16.259998321533203,16.200000762939453,15.899999618530273,16.079999923706055,16.079999923706055,15.699999809265137,15.660000801086426,16.139999389648438,23.100000381469727,16.600000381469727,16.420000076293945,16.020000457763672,15.619999885559082,16.35999870300293,15.719999313354492,15.920001029968262,15.5600004196167,16.34000015258789,22.82000160217285,15.660000801086426,15.5600004196167,16,16,15.819999694824219,16.399999618530273,16.46000099182129,16.059999465942383,16.239999771118164,15.800000190734863,16.15999984741211,16.360000610351562,19.700000762939453,16.10000228881836,16.139999389648438,15.819999694824219,16.439998626708984,16.139999389648438,16.020000457763672,15.860000610351562,16.059999465942383,16.020000457763672,15.920000076293945,15.819999694824219,16.579999923706055,15.880000114440918,16.579999923706055,15.699999809265137,19.380001068115234,19.239999771118164,16,15.980000495910645,15.959999084472656,16.200000762939453,15.980000495910645,16.34000015258789,16.31999969482422,16.260000228881836,15.920000076293945,15.540000915527344,16.139999389648438,16.459999084472656,16.34000015258789,15.819999694824219,19.719999313354492,15.75999927520752,16.499998092651367,15.719999313354492,16.079999923706055,16.439998626708984,16.200000762939453,15.959999084472656,16,16.100000381469727,19.31999969482422,16.100000381469727,16.18000030517578,15.959999084472656,22.639999389648438,15.899999618530273,16.279998779296875,16.100000381469727,15.920000076293945,16.079999923706055,16.260000228881836,15.899999618530273,15.820001602172852,15.699999809265137,15.979998588562012,16.380001068115234,16.040000915527344,19.420000076293945,15.9399995803833,16.15999984741211,15.960000991821289,16.259998321533203,15.780000686645508,15.880000114440918,15.980000495910645,16.060001373291016,16.119998931884766,23.020000457763672,15.619999885559082,15.920000076293945,16.060001373291016,14.780000686645508,16.260000228881836,19.520000457763672,16.31999969482422,16.600000381469727,16.219999313354492,19.740001678466797,19.46000099182129,15.940000534057617,15.839999198913574,16.100000381469727,16.46000099182129,16.17999839782715,16.100000381469727,15.9399995803833,16.060001373291016,15.860000610351562,15.819999694824219,16.03999900817871,16.17999839782715,15.819999694824219,17.299999237060547,15.9399995803833,15.739999771118164,15.719999313354492,15.679998397827148,15.619999885559082,15.600000381469727,16.03999900817871,15.5,15.600001335144043,19.439998626708984,15.960000991821289,16.239999771118164,16.040000915527344,16.239999771118164],
    square= [24.200000762939453,17.899999618530273,15.800000190734863,58.400001525878906,151,2523.10009765625,245.3000030517578,136,72.30000305175781,55.70000076293945,42.400001525878906,37.70000076293945,30.100000381469727,30.100000381469727,21.799999237060547,20.600000381469727,21.799999237060547,17.600000381469727,18.200000762939453,21,941.7000122070312,177.39999389648438,2821.800048828125,359.20001220703125,318,217.10000610351562,126,69,57.79999923706055,45.29999923706055,35.599998474121094,29.100000381469727,23.799999237060547,44.20000076293945,17.700000762939453,17.700000762939453,15.699999809265137,27.799999237060547,22.799999237060547,3853.60009765625,91.5999984741211,181.39999389648438,476.29998779296875,265.8999938964844,254.60000610351562,2583.199951171875,124.80000305175781,73.19999694824219,56.400001525878906,48.70000076293945,41.599998474121094,21.100000381469727,20.299999237060547,21.299999237060547,18.299999237060547,17.100000381469727,19.5,828.2000122070312,162.1999969482422,217.89999389648438,205.5,197.60000610351562,2249.800048828125,103.0999984741211,71.69999694824219,57.599998474121094,41.400001525878906,34.5,22,20.5,21.700000762939453,18.299999237060547,17.299999237060547,19.399999618530273,666.7999877929688,214.89999389648438,212.3000030517578,125.80000305175781,67.69999694824219,56.099998474121094,45.79999923706055,38.29999923706055,33,35.400001525878906,22.700000762939453,19.399999618530273,19.899999618530273,24.100000381469727,19.299999237060547,21.299999237060547,3508.699951171875,204.10000610351562,125.4000015258789,65.30000305175781,60.79999923706055,44.099998474121094,36.29999923706055,30.5,28.600000381469727,16.5,18.600000381469727,23.700000762939453,22.299999237060547,17.600000381469727,19.200000762939453,448.79998779296875,124.4000015258789,66.5999984741211,53.5,51,45.20000076293945,28.399999618530273,29.200000762939453,26.700000762939453,25.899999618530273,18.100000381469727,17.600000381469727,20.100000381469727,25.200000762939453,3332,67.5,53.599998474121094,56.599998474121094,39.900001525878906,27.600000381469727,29.600000381469727,33.5,17.200000762939453,18.799999237060547,25.200000762939453,16.700000762939453,16.899999618530273,240.1999969482422,52.400001525878906,42.099998474121094,33.900001525878906,28,28.600000381469727,17.299999237060547,20,21,22.799999237060547,16.700000762939453,19.200000762939453,175.39999389648438,43.5,34.70000076293945,29.700000762939453,34.900001525878906,25.799999237060547,17.299999237060547,22.600000381469727,17.600000381469727,17.200000762939453,19.200000762939453,111.80000305175781,35.400001525878906,27.600000381469727,25.399999618530273,21.899999618530273,18.600000381469727,18.100000381469727,21.200000762939453,17.899999618530273,17,80.5999984741211,29.799999237060547,30.100000381469727,16,26.799999237060547,17.5,22.299999237060547,16.799999237060547,22.399999618530273,77.4000015258789,31,29.700000762939453,28.700000762939453,26,16.899999618530273,15.800000190734863,19,52.599998474121094,25.200000762939453,16.700000762939453,17.899999618530273,21,19.799999237060547,18.799999237060547,46.5,17.5,16.799999237060547,18.299999237060547,18.299999237060547,14.899999618530273,41,18.299999237060547,17.299999237060547,17,17.5,32.29999923706055,22.600000381469727,16.600000381469727,17.899999618530273,25.600000381469727,17.5,20.299999237060547,25.200000762939453,18.600000381469727,17.700000762939453]
)

data |>
@vlplot(
    width=400,
    height=200,
    x={
        "row:q",
        title="Trial",
        scale={nice=false},
        axis={grid=false}
    },
    y={
        "fps:q",
        title="Frames Per Second (fps)",
        scale={type="log"},
        axis={grid=false}
    },
    color={
        "system:n",
        title="System",
        legend={orient="bottom-right"}
    },
    "size"={value=1}
) +
@vlplot(
    mark=:line,
    transform=[
        {window=[{field="falcon",op="row_number",as="row"}]},
        {calculate="1000/datum.falcon",as="fps"},
        {calculate="'Falcon'",as="system"}
    ]
) +
@vlplot(
    mark=:line,
    transform=[
        {window=[{field="square",op="row_number",as="row"}]},
        {calculate="1000/datum.square",as="fps"},
        {calculate="'Square Crossfilter (3M)'",as="system"}
    ]
)
```

## Quantile-Quantile Plot (QQ Plot)

```@example
using VegaLite, VegaDatasets

dataset("normal-2d") |>
@vlplot(
    columns=2,
    transform=[
        {
            quantile="u",
            step=0.01,
            as=["p","v"]
        },
        {
           calculate="quantileUniform(datum.p)",as="unif"
        },
        {
           calculate="quantileNormal(datum.p)",as="norm"
        }
    ]
) + [
    @vlplot(
        mark=:point,
        x="unif:q",
        y="v:q"
    );
    @vlplot(
        mark=:point,
        x="norm:q",
        y="v:q"
    )
]
```

## Linear Regression

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
layer=[{
    mark={:point,filled=true},
    x="Rotten_Tomatoes_Rating:q",
    y="IMDB_Rating:q"
},
{
    transform=[
        {
            regression="IMDB_Rating",
            on="Rotten_Tomatoes_Rating"
        }
    ],
    mark={:line,color="firebrick"},
    x="Rotten_Tomatoes_Rating:q",
    y="IMDB_Rating:q"
},
{
    transform=[
        {
            regression="IMDB_Rating",
            on="Rotten_Tomatoes_Rating",
            params=true
        },
        {
            calculate="'R²: '+format(datum.rSquared, '.2f')",
            as="R2"
        }
    ],
    mark={:text,color="firebrick",x="width",align="right",y=-5},
    text={"R2:n"}
}]
)
```

## Loess Regression

```@example
using VegaLite, VegaDatasets

dataset("movies") |>
@vlplot(
layer=[{
    mark={:point,filled=true},
    x="Rotten_Tomatoes_Rating:q",
    y="IMDB_Rating:q"
},
{
    transform=[
        {
            loess="IMDB_Rating",
            on="Rotten_Tomatoes_Rating"
        }
    ],
    mark={:line,color="firebrick"},
    x="Rotten_Tomatoes_Rating:q",
    y="IMDB_Rating:q"
}]
)
```
