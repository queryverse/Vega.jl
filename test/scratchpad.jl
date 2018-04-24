
reload("VegaLite")

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

##################################################################

import Distributions
xs = rand(Distributions.Normal(), 100, 3)

dt = [ @NT( a = xs[i,1] + xs[i,2] .^ 2,
            b = xs[i,3] .* xs[i,2],
            c = xs[i,3] .+ xs[i,2] )  for i in 1:size(xs,1) ]

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

###################################

durl = "file://c:/users/frtestar/downloads/etherprice.2.csv"

using CSV

download(, "/tmp/etherprice.2.csv")

fn = "c:/users/frtestar/downloads/etherprice.2.csv"
fn = "/tmp/etherprice.2.csv"

df = CSV.read(fn, header=["date", "value"], delim=';')
df[:date2] = DateTime("1970-01-01") + Dates.Second.(Array(df[:date]))

df2 = readdlm("c:/users/frtestar/downloads/etherprice.2.csv", ';', header=false)

dfd = [ Dict(zip(names(df), vec(df2[i,:]))) for i in 1:size(df,1) ]

# dv = get(df[1,1])
# DateTime(round(Int, dv/1000000))
# DateTime("1970-01-01") + Dates.Second(dv)
dvs = DateTime("1970-01-01") + Dates.Second.(round(Int, df2[:,1]))

dfd2 = [ Dict(zip([:date1, :value, :date2 ], [df2[i,1:2]; dvs[i]] )) for i in 1:size(df,1) ]

data(df) |>
  layer(markline(),
        encoding(xtemporal(field=:date2, vlaxis(labelAngle=-30)), #labelFont="Helvetica")),
                 yquantitative(field="value", vlscale(typ=:log)))
       ) |>
  layer(markarea(),
        encoding(xtemporal(field="date2"),
                 yquantitative(field="value", vlscale(typ=:log)),
                 vlopacity(value=0.5))
       ) |>
  config(timeFormat="%b-%Y") |>
  plot(width=600, height=300)


##########################################################################


rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/data/"
durl = rooturl * "unemployment-across-industries.json"

data(url=durl) |>
  plot(width=600, height=400) |>
  markline(interpolate="step-before") |>
  transform(filter="datum.series=='Agriculture'") |>
  encoding(xtemporal(timeUnit="yearmonth", field="date",
                     vlscale(nice="month"),
                     vlaxis(format="%Y", labelAngle=-45)),
           yquantitative(aggregate=:sum, field=:count),
           colornominal(field=:series, vlscale(scheme="category20b"))
           )

############################################################################

using DataFrames

df  = DataFrame(x=[1:7;], y=rand(7))
dfd = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]

encx = xquantitative(field=:x)
ency = yquantitative(field=:y)

data(values=dfd) |>
  plot(width=500) |>
  layer(markline(),
        encoding(encx, ency, vlcolor(value="green"))) |>
  layer(markline(interpolate="cardinal"),
        encoding(encx, ency, vlcolor(value="blue"))) |>
  layer(markline(interpolate="basis"),
        encoding(encx, ency, vlcolor(value="red"))) |>
  layer(markpoint(),
        encoding(encx, ency, vlcolor(value="black"), vlsize(value=50)))


###########################################################################

r, nb = 5., 10
df = DataFrame(n = [1:nb;],
               x = r * (0.2 + rand(nb)) .* cos.(2π * linspace(0,1,nb)),
               y = r * (0.2 + rand(nb)) .* sin.(2π * linspace(0,1,nb)))

dfd = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]

encx = xquantitative(field=:x, vlscale(zero=false))
ency = yquantitative(field=:y, vlscale(zero=false))
encn = orderquantitative(field=:n)

data(values=dfd) |>
  layer(markline(interpolate="basis-closed"),
        encoding(encx, ency, encn, vlcolor(value="blue"))) |>
  layer(markpoint(),
        encoding(encx, ency, vlcolor(value="black"), vlsize(value=50)))


data(values=dfd) |>
  layer(markline(interpolate="basis-closed"),
        encoding(encx, ency, encn, vlcolor(value="blue"))) |>
  layer(markpoint(),
        encoding(encx, ency, vlcolor(value="black"), vlsize(value=50)))


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

xchan = xordinal(field=:age, vlaxis(labelAngle=-45))
ychan = yquantitative(field=:people)

tpop = vlaxis(title="population")
ymin = yquantitative(aggregate=:min, field=:people, tpop)
ymax = yquantitative(aggregate=:max, field=:people, tpop)
y2max = y2quantitative(aggregate=:max, field=:people)
ymean = yquantitative(aggregate=:mean, field=:people, tpop)

data(url=durl) |>
  transform(filter="datum.year==2000") |>
  layer(marktick(),  encoding(xchan, ymin, vlsize(value=5))) |>
  layer(marktick(),  encoding(xchan, ymax, vlsize(value=5))) |>
  layer(markpoint(), encoding(xchan, ymean, vlsize(value=5))) |>
  layer(markrule(),  encoding(xchan, ymin, y2max))

###########################################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/cars.json"

data(url=durl) |>
  markrect() |>
  encoding(xordinal(field=:Origin),
           yordinal(field=:Cylinders),
           colorquantitative(aggregate=:mean, field=:Horsepower)) |>
  plot(width=200, height=200)


############################################################
