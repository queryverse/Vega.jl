@time using VegaLite

module VegaLite

    todicttree(abcd="yo", xyz=456)
    todicttree("yo", "abcd")
    todicttree(["yo", "abcd"])
    todicttree(["yo", "abcd"], tets=45)

    plot( mark.point(), width=400,
          enc.x.nominal(:x, bin=@NT(maxbins=10)),
          enc.y.nominal(:yyy) ).params

end

module VegaLite ; end


using VegaLite # 55s w/ precompilation, 23s w/o precompilation
using NamedTuples
using ElectronDisplay

############################################################

durl = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

p = plot(data(url=durl),
         mk.circle(),
         enc.x.quantitative(:IMDB_Rating, bin=@NT(maxbins=10)),
         enc.y.quantitative(:Rotten_Tomatoes_Rating, bin=@NT(maxbins=10)),
         enc.size.quantitative(:*, aggregate=:count),
         width=300, height=300) ;

display(p)
pdf("c:/temp/ex.pdf", p)

Dict()

##################################################################

import Distributions
xs = rand(Distributions.Normal(), 100, 3)

dt = [ @NT( a = xs[i,1] + xs[i,2] .^ 2,
            b = xs[i,3] .* xs[i,2],
            c = xs[i,3] .+ xs[i,2] )  for i in 1:size(xs,1) ]

data(dt)

p = dt |>
  plot( rep(column = [:a, :b, :c], row = [:a, :b, :c]),
        spec(mk.point(),
             enc.x.quantitative(@NT(repeat=:column)),
             enc.y.quantitative(@NT(repeat=:row))));

p = plot(data(dt),
         rep(column = [:a, :b, :c], row = [:a, :b, :c]),
         spec(mk.point(),
         enc.x.quantitative(@NT(repeat=:column)),
         enc.y.quantitative(@NT(repeat=:row))));

display(p)
###################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/data/"
durl = rooturl * "unemployment-across-industries.json"

VegaLite.todicttree([@NT(filter="datum.series=='Agriculture'")])
VegaLite.togoodarg([@NT(filter="datum.series=='Agriculture'")])

display(plot(data(url=durl),
     width=600, height=400,
     mk.line(interpolate="step-before"),
     transform([@NT(filter="datum.series=='Agriculture'")]),
     enc.x.temporal(:date, timeUnit="yearmonth",
                    scale=@NT(nice="month"),
                    axis=@NT(format="%Y", labelAngle=-45)),
     enc.y.quantitative(:count, aggregate=:sum),
     enc.color.nominal(:series, scale=@NT(scheme="category20b")) ) )

############################################################################

import DataFrames

df  = DataFrames.DataFrame(x=[1:7;], y=rand(7))
# dfd = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]

encx = enc.x.quantitative(:x)
ency = enc.y.quantitative(:y)

display( df |>
  plot(width=500,
       layer((mk.line(), encx, ency, enc.color.value(:green)),
             (mk.line(interpolate=:cardinal), encx, ency, enc.color.value(:blue)),
             (mk.line(interpolate=:basis), encx, ency, enc.color.value(:red)),
             (mk.point(), encx, ency, enc.color.value(:black), enc.size.value(50))) )
   )


###########################################################################

r, nb = 5., 10
df = DataFrames.DataFrame(n = [1:nb;],
               x = r * (0.2 + rand(nb)) .* cos.(2π * linspace(0,1,nb)),
               y = r * (0.2 + rand(nb)) .* sin.(2π * linspace(0,1,nb)))

encx = enc.x.quantitative(:x, scale=@NT(zero=false))
ency = enc.y.quantitative(:y, scale=@NT(zero=false))
encn = enc.order.quantitative(:n)

display(
  plot(data(df),
       layer((mk.line(interpolate="basis-closed"), encx, ency, encn,
               enc.color.value(:blue)),
             (mk.point(), encx, ency, enc.color.value(:black), enc.size.value(50)))
      ) )


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

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/population.json"

xchan = enc.x.ordinal(:age, axis=@NT(labelAngle=-45))
ychan = enc.y.quantitative(:people)

tpop = @NT(title="population")
ymin = enc.y.quantitative(:people, aggregate=:min, axis=tpop)
ymax = enc.y.quantitative(:people, aggregate=:max, axis=tpop)
y2max = enc.y2.quantitative(:people, aggregate=:max)
ymean = enc.y.quantitative(:people, aggregate=:mean, axis=tpop)

VegaLite.vltype(layer( VegaLite.mark.tick(), xchan, ymin, enc.size.value(5) ) )
VegaLite.vlname(:vllayer)

plot(data(url=durl),
     transform([filter="datum.year==2000"]),
     layer( [mk.tick(), xchan, ymin, enc.size.value(5)] ))

VegaLite.todicttree(data(url=durl),
     transform([filter="datum.year==2000"]),
     layer( (mk.tick(), xchan, ymin, enc.size.value(5)) ))

VegaLite.todicttree((xchan, ymin))


plot(data(url=durl),
     transform(@NT(filter="datum.year==2000")),
     layer(( mk.tick(),   xchan, ymin,  enc.size.value(5) ),
           ( mk.tick(),   xchan, ymax,  enc.size.value(5) ),
           ( mk.point(),  xchan, ymean, enc.size.value(5) ),
           ( mk.rule(),   xchan, ymin,  y2max) ))


###########################################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/cars.json"

display(
    plot(data(url=durl),
         mk.rect(), enc.x.ordinal(:Origin), enc.y.ordinal(:Cylinders),
         enc.color.quantitative(:Horsepower, aggregate=:mean),
         width=200, height=200) )


############### maps  ########################################


###########  query widgets  ########################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/cars.json"

layer1 = (selection(CylYr=@NT(typ=:single, fields=["Cylinders", "Year"],
                              bind=@NT(Cylinders=@NT(input=:range, min=3, max=8, step=1),
                                       Year=@NT(input=:range, min=1969, max=1981, step=1) ))),
          mk.circle(),
          enc.x.quantitative(:Horsepower),
          enc.y.quantitative(:Miles_per_Gallon),
          enc.color.value(:grey, condition=@NT(selection=:CylYr, field=:Origin, typ=:nominal)))

layer2 = (transform([@NT(filter=@NT(selection=:CylYr))]),
          mk.circle(),
          enc.x.quantitative(:Horsepower),
          enc.y.quantitative(:Miles_per_Gallon),
          enc.color.nominal(:Origin),
          enc.size.value(100))

p = plot(data(url=durl),
         description="Drag the sliders to highlight points.",
         # transform([@NT(calculate="year(datum.Year)", as="Year")]),
         layer([layer1, layer2]) );
display(p)

############ cross filter  ###################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/flights-2k.json"

layer1 = (selection(brush=@NT(typ=:interval, encodings=[:x])),
          mk.bar(),
          enc.x.quantitative(@NT(repeat=:column), bin=@NT(maxbins=20)),
          enc.y.quantitative(:*, aggregate=:count) )

layer2 = (transform([@NT(filter=@NT(selection=:brush))]),
          mk.bar(),
          enc.x.quantitative(@NT(repeat=:column), bin=@NT(maxbins=20)),
          enc.y.quantitative(:*, aggregate=:count),
          enc.color.value(:goldenrod) )

p = plot(data(url=durl, format=@NT(parse=@NT(date=:date))),
         transform([@NT(calculate="hours(datum.date)", as=:time)]),
         rep(column=["distance", "delay", "time"]),
         spec=@NT(layer=[layer1, layer2]) );

display(p)


##################  maps ###################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/income.json"
topourl = rooturl * "data/us-10m.json"
clipboard(topourl)

p = plot(width=250, height=150,
         data(url=durl),
         transform([@NT(lookup=:id, as=:geo,
                       from=@NT(
                        data=@NT(
                          url=rooturl * "data/us-10m.json",
                          format=@NT(typ=:topojson, feature=:states)),
                        key=:id))]),
          projection=@NT(typ=:albersUsa),
          mk.geoshape(),
          enc.shape.geojson(:geo),
          enc.color.quantitative(:pct),
          enc.row.nominal(:group)
          );
display(p)



topourl = "https://raw.githubusercontent.com/deldersveld/topojson/master/countries/japan/jp-towns.json"
http://www.naturalearthdata.com/downloads/110m-cultural-vectors/jp-towns.json

topourl = "https://raw.githubusercontent.com/deldersveld/topojson/master/countries/italy/italy-regions.json"

p = plot(
    width=500, height=500,
    data(url=topourl, format=@NT(typ=:topojson, feature=:ITA_adm1)),
    projection=@NT(typ=:orthographic),
    mk.geoshape(stroke=:black)
    ) ;

VegaLite.display(Base.REPL.REPLDisplay(), p)

tmppath = string(tempname(), ".vegalite.html")

open(tmppath, "w") do io
    VegaLite.writehtml_partial(io, JSON.json(p.params))
end


tmppath = VegaLite.writehtml_full(JSON.json(p.params))
VegaLite.launch_browser(tmppath) # Open the browser

VegaLite.vlprojection
    "data": {
      "url": "data/us-10m.json",
      "format": {
        "type": "topojson",
        "feature": "states"
      }
    },
    "mark": {
      "type": "geoshape",
      "fill": "lightgray",
      "stroke": "white"
    }


{
  "$schema": "https://vega.github.io/schema/vega-lite/v2.1.json",
  "width": 500,
  "height": 300,
  "data": {
    "url": "data/income.json"
  },
  "transform": [
    {
      "lookup": "id",
      "from": {
        "data": {
          "url": "data/us-10m.json",
          "format": {
            "type": "topojson",
            "feature": "states"
          }
        },
        "key": "id"
      },
      "as": "geo"
    }
  ],
  "projection": {"type": "albersUsa"},
  "mark": "geoshape",
  "encoding": {
    "shape": {"field": "geo","type": "geojson"},
    "color": {"field": "pct","type": "quantitative"},
    "row": {"field": "group","type": "nominal"}
  }
}
