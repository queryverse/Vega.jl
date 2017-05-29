
module A
end


###################################################################
#   function creation
###################################################################


include("../src/schema_parsing.jl")
include("../src/func_definition.jl")
include("../src/render.jl")


###################################

durl = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

plot(data(url=durl),
     mark="circle",
     encoding(_x(_bin(maxbins=10), field="IMDB_Rating", _type="quantitative"),
              _y(_bin(maxbins=10), field="Rotten_Tomatoes_Rating", _type="quantitative"),
              _color(field="Rotten_Tomatoes_Rating", _type="quantitative"),
              _size(aggregate="count", _type="quantitative")),
     width=600, height=600)

plot

##########################################################################

# TODO : comment faire le "axis": null ???

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/data/"
durl = rooturl * "unemployment-across-industries.json"

plot(data(url=durl),
     width=600, height=400,
     mark="area",
     encoding(x(timeUnit="yearmonth", field="date", typ="temporal",
                scale(nice="month"),
                axis(domain=false, format="%Y", labelAngle=-45, tickSize=10)),
              y(aggregate="sum", field="count", typ="quantitative",
                stack="center"),
              color(field="series", typ="nominal", scale(scheme="category20b"))
             )
     )

############################################################################

# TODO le schema json ne contient pas la def de "brush", ni "grid"

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/data/"
durl = rooturl * "data/cars.json"

plot(repeat(row    = ["Horsepower","Acceleration"],
            column = ["Horsepower", "Miles_per_Gallon"]),
     spec(
          data(url=durl),
          mark="point",
          selection(
                    # brush(typ="interval", resolve="union",
                    #       encodings=["x"],
                    #       on="[mousedown[event.shiftKey], mouseup] > mousemove",
                    #       translate="[mousedown[event.shiftKey], mouseup] > mousemove"),
                    grid(typ="interval", resolve="global",
                         bind="scales",
                         translate="[mousedown[!event.shiftKey], mouseup] > mousemove")
                   ),
          encoding(
                    x(field(repeat="row"), typ="quantitative"),
                    y(field(repeat="column"), typ="quantitative"),
                    color(field="Origin", typ="nominal",
                          condition(selection="!brush", value="grey"))
                    )
          )
     )

# brush pas encore définie


###########################################################################

{
  "$schema": "https://vega.github.io/schema/vega-lite/v2.json",
  "description": "A error bar plot showing mean, min, and max in the US population distribution of age groups in 2000.",
  "data": {"url": "data/population.json"},
  "transform": [{"filter": "datum.year == 2000"}],
  "layer": [
    {
      "mark": "rule",
      "encoding": {
        "x": {"field": "age","type": "ordinal"},
        "y": {
          "aggregate": "min",
          "field": "people",
          "type": "quantitative",
          "axis": {"title": "population"}
        },
        "y2": {
          "aggregate": "max",
          "field": "people",
          "type": "quantitative"
        }
      }
    },
    {
      "mark": "tick",
      "encoding": {
        "x": {"field": "age","type": "ordinal"},
        "y": {
          "aggregate": "min",
          "field": "people",
          "type": "quantitative",
          "axis": {"title": "population"}
        },
        "size": {"value": 5}
      }
    },
    {
      "mark": "tick",
      "encoding": {
        "x": {"field": "age","type": "ordinal"},
        "y": {
          "aggregate": "max",
          "field": "people",
          "type": "quantitative",
          "axis": {"title": "population"}
        },
        "size": {"value": 5}
      }
    },
    {
      "mark": "point",
      "encoding": {
        "x": {"field": "age","type": "ordinal"},
        "y": {
          "aggregate": "mean",
          "field": "people",
          "type": "quantitative",
          "axis": {"title": "population"}
        },
        "size": {"value": 2}
      }
    }
  ]
}



rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/population.json"
println(durl)
xchan = x(field="age", typ="ordinal", axis(labelAngle=-45))
ychan = y(field="people", typ="quantitative")

ymin = y(aggregate="min", field="people", typ="quantitative",
         axis(title="population"))
ymax = y(aggregate="max", field="people", typ="quantitative",
        axis(title="population"))
y2max = y2(aggregate="max", field="people", typ="quantitative",
        axis(title="population"))
ymean = y(aggregate="mean", field="people", typ="quantitative",
                axis(title="population"))


plot(data(url=durl),
     transform=[ Dict(filter => "datum.year==2000")],
     layer(mark="tick",  encoding(xchan, ymin, size(value=5))),
     layer(mark="tick",  encoding(xchan, ymax, size(value=5))),
     layer(mark="point", encoding(xchan, ymean, size(value=5))),
     layer(mark="rule",  encoding(xchan, ymin, y2max))
     )

plot(data(url=durl),
     layer(mark="point", encoding(xchan, ychan)),
     layer(mark="line",  encoding(xchan, ymean)),
     width=800, height=600
    )



###########################################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/cars.json"

plot(data(url=durl),
     mark="rect",
     encoding(x(field="Origin", typ="ordinal"),
              y(field="Cylinders", typ="ordinal"),
              color(aggregate="mean", field="Horsepower", typ="quantitative")),
     width=200, height=200,
    )


############################################################


defs["plot"]

getdesc(s::RefDef) = s.desc * "\n" * getdesc(defs[s.ref])
getdesc(s::SpecDef) = s.desc
getdesc(s::VoidDef) = ""

function getdesc(s::ObjDef)
  ret = s.desc
  ret *= "\n\n# Arguments\n\n"
  for (k,v) in s.props
    vs = "`$k` ($(typeof(v)))"
    ret *= "  * $vs : " * getdesc(v) * "\n\n"
  end
  return ret
end

function getdesc(s::UnionDef)
  ret = s.desc
  ret *= "\n\n# One of :\n\n"
  for v in s.items
    ret *= "  * " * getdesc(v) * "\n\n"
  end
  return ret
end


println(getdesc(defs["EncodingWithFacet<Field>"]))


println(getdesc(defs["EqualFilter"]))
