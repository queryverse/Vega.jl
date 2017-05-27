
module A
end


###################################################################
#   function creation
###################################################################


include("../src/schema_parsing.jl")
include("../src/func_definition.jl")
include("../test/render.jl")


vals = JSON.parse("""
{
  "values": [
    {"a": "C", "b": 2}, {"a": "C", "b": 7}, {"a": "C", "b": 4},
    {"a": "D", "b": 1}, {"a": "D", "b": 2}, {"a": "D", "b": 6},
    {"a": "E", "b": 8}, {"a": "E", "b": 4}, {"a": "E", "b": 7}
  ]
}
""")


p = plot(data = vals,
     mark = "point",
     encoding(x(field="a", typ="nominal"),
              y(field="b", typ="quantitative"))) ;

p
p.json
layer


encoding(x(field="a"))




plot(data = vals,
     layer(mark = "point",
           encoding(x(field="a", typ="nominal"),
                    y(field="b", typ="quantitative")) ),
     layer(mark = "line",
           encoding(x(field="a", typ="nominal"),
                    y(field="b", typ="quantitative")))
    )
encoding(x(field="a"), x(field="a"))


###################################

{
  "$schema": "https://vega.github.io/schema/vega-lite/v2.json",
  "data": {"url": "data/movies.json"},
  "mark": "circle",
  "encoding": {
    "x": {
      "bin": {"maxbins": 10},
      "field": "IMDB_Rating",
      "type": "quantitative"
    },
    "y": {
      "bin": {"maxbins": 10},
      "field": "Rotten_Tomatoes_Rating",
      "type": "quantitative"
    },
    "size": {
      "aggregate": "count",
      "type": "quantitative"
    }
  }
}

dat = download("https://github.com/bantic/imdb-data-scraping/blob/master/data/movies.json")

dat = readall(joinpath(dirname(@__FILE__), "../examples/movies.json") )
show(dat)
dat2 = JSON.parse(dat)


fsrc = joinpath(dirname(@__FILE__), "../examples/movies.json")

plot(data(url="data/movies.json"),
     mark="circle",
     encoding(x(bin(maxbins=10), field="IMDB_Rating", typ="quantitative"),
              y(bin(maxbins=10), field="Rotten_Tomatoes_Rating", typ="quantitative"),
              size(aggregate="count", typ="quantitative"))
     )


data(url=465)

url




plot(data = vals,
     mark = "point",
     encoding(y(field="b", typ="quantitative")))






@doc "doc of encoding" encoding




########################################

vls =
"""
  {
    "data": {
      "values": [
        {"a": "C", "b": 2}, {"a": "C", "b": 7}, {"a": "C", "b": 4},
        {"a": "D", "b": 1}, {"a": "D", "b": 2}, {"a": "D", "b": 6},
        {"a": "E", "b": 8}, {"a": "E", "b": 4}, {"a": "E", "b": 7}
      ]
    },
    "mark": "point",
    "encoding": {
      "x": {"field": "a", "type": "nominal"}
    }
  }
"""

{
 "mark":"bar",
 "data":{
  "values":[{"b":2,"a":"C"},{"b":7,"a":"C"},{"b":4,"a":"C"},
            {"b":1,"a":"D"},{"b":2,"a":"D"},{"b":6,"a":"D"},
            {"b":8,"a":"E"},{"b":4,"a":"E"},{"b":7,"a":"E"}]
        },
  "encoding": {
    "y":{
      "field":"temp",
      "type":"quantitative",
      "aggregate":"mean"},
    "x":{
      "timeUnit":"month",
      "field":"date",
      "type":"temporal"}
    }
}



JSON.parse(vls)

include("render.jl")

po = VLSpec{:plot}(vls) ;
show(po)


JSON.json(Dict("abcd" => VLSpec{:test}("abcs")))

schs = """{
  "\$schema": "https://vega.github.io/schema/vega-lite/v2.json",
  "data": {"url": "data/seattle-temps.csv"},
  "mark": "bar",
  "encoding": {
    "x": {
      "timeUnit": "month",
      "field": "date",
      "type": "temporal"
    },
    "y": {
      "aggregate": "mean",
      "field": "temp",
      "type": "quantitative"
    }
  }
}
"""


#### tuples of pairs  ########

plot(:data => ("data/seattle-temps.csv"),
     :mark => "bar",
     :encoding => (:x => (:timeUnit => "month",
                          :field => "date",
                          :type => "temporal" ),  # pb with 'type' field name
                   :y => (:aggregate => "mean",
                          :field => "temp",
                          :type => "quantitative" ))
    )
