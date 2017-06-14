
module A
end

reload("VegaLite")

module A

using VegaLite

############################################################

durl = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

tstf(;kwargs...) = foreach( t -> println("$(t[1]) -> $(t[2])"), kwargs)
tstf(url=durl)

plot(vldata(url=durl),
     mark="circle",
     vlencoding(vlx(vlbin(maxbins=10), field=:IMDB_Rating, typ=:quantitative),
                vly(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating, typ=:quantitative),
                vlcolor(field=:Rotten_Tomatoes_Rating, typ=:quantitative),
                vlsize(aggregate=:count, typ=:quantitative)),
     width=300, height=300)


plot(data(url=durl),
     markcircle(),
     encoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
                yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
                colorquantitative(field=:Rotten_Tomatoes_Rating),
                sizequantitative(aggregate=:count)),
     width=300, height=300)

data(url=durl) |>
  plot(width=200, height=100) |>
  markcircle() |>
  vlencoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
             yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
             colorquantitative(field=:Rotten_Tomatoes_Rating),
             sizequantitative(aggregate=:count))

p.params

p
fieldnames(p)

using JSON

function tst(p)
  pd = JSON.parse(p.json)
  VegaLite.conforms(pd, "plot(..", VegaLite.defs["plot"])
end


tst(p)

data(url=durl) |>
  transform(vlfilter(field=:IMDB_Rating, oneOf= [1,2])) |>
  # transform(filter=" datum.Scope2 == 'Hedged'") |>
  markcircle() |>
  encoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
           yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
           colorquantitative(field=:Rotten_Tomatoes_Rating),
           sizequantitative(aggregate="count")) |>
  plot(width=300, height=300)


showall(keys(VegaLite.defs))
##################################################################

using Distributions
using DataTables
xs = rand(Normal(), 100, 3)
dt = DataTable(a = xs[:,1] + xs[:,2] .^ 2,
               b = xs[:,3] .* xs[:,2],
               c = xs[:,3] .+ xs[:,2])

data(dt) |>
  repeat(column = [:a, :b, :c], row = [:a, :b, :c]) |>
  spec(markpoint(),
       encoding(xquantitative(vlfield(repeat=:column)),
                yquantitative(vlfield(repeat=:row))))



###################################

durl = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

plot(_data(url=durl),
     mark="circle",
     _encoding(_x(_bin(maxbins=10), field="IMDB_Rating", typ="quantitative"),
               _y(_bin(maxbins=10), field="Rotten_Tomatoes_Rating", typ="quantitative"),
               _color(field="Rotten_Tomatoes_Rating", typ="quantitative"),
               _size(aggregate="count", typ="quantitative")),
     width=300, height=300)

p = plot(_data(url=durl),
     mark="circle",
     _encoding(_x(_bin(maxbins=10), field="IMDB_Rating", typ="quantitative"),
               _y(_bin(maxbins=10), field="Rotten_Tomatoes_Rating", typ="quantitative"),
               _color(field="Rotten_Tomatoes_Rating", typ="quantitative"),
               _size(aggregate="count", typ="quantitative")),
     width=300, height=300) ;

p

show(p)

###################################################################

using Distributions
using DataTables

xs = rand(Normal(), 100, 3)
dt = DataTable(a = xs[:,1] + xs[:,2] .^ 2,
               b = xs[:,3] .* xs[:,2],
               c = xs[:,3] .+ xs[:,2])

recs = [ Dict(r) for r in DataTables.eachrow(dt) ]
VegaLite.VLSpec{:data}(Dict("values" => recs))


data(dt) |>
  repeat(column = [:a, :b, :c], row = [:a, :b, :c]) |>
  spec(markpoint(),
       encoding(xquantitative(vlfield(repeat=:column)),
                yquantitative(vlfield(repeat=:row)),
                colorquantitative(field=:a)) )

methods(data)

###################################

durl = "file://c:/users/frtestar/downloads/etherprice.2.csv"

using CSV

download(, "/tmp/etherprice.2.csv")

df = CSV.read("/tmp/etherprice.2.csv",
              header=["date", "value"], delim=';')

df2 = readdlm("c:/users/frtestar/downloads/etherprice.2.csv", ';', header=false)

dfd = [ Dict(zip(names(df), vec(df2[i,:]))) for i in 1:size(df,1) ]

# dv = get(df[1,1])
# DateTime(round(Int, dv/1000000))
# DateTime("1970-01-01") + Dates.Second(dv)
dvs = DateTime("1970-01-01") + Dates.Second.(round(Int, df2[:,1]))

dfd2 = [ Dict(zip([:date1, :value, :date2 ], [df2[i,1:2]; dvs[i]] )) for i in 1:size(df,1) ]

plot(data(values=dfd2),
     layer(mark="line",
          encoding(x_(field="date2", type_="temporal",
                      axis(labelAngle=-30, labelFont="Helvetica")),
                   y_(field="value", type_="quantitative",
                   scale_(type_="log")))),
     layer(mark="area",
          encoding(x_(field="date2", type_="temporal"),
                   y_(field="value", type_="quantitative",
                      scale_(type_="log")),
                   opacity_(value=0.5))),
     config(timeFormat="%b-%Y"),
     width=600, height=300)


##########################################################################

# TODO : comment faire le "axis": null ???

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/data/"
durl = rooturl * "unemployment-across-industries.json"

plot(data(url=durl),
     width=600, height=400,
     mark_="area",
     encoding(x_(timeUnit="yearmonth", field="date", type_="temporal",
                scale_(nice="month"),
                axis(domain=false, format="%Y", labelAngle=-45, tickSize=10)),
              y_(aggregate="sum", field="count", type_="quantitative",
                stack="center"),
              color_(field="series", type_="nominal", scale_(scheme="category20b"))
             )
     )

plot(data(url=durl),
    width=600, height=400,
    mark_(type_="line", interpolate="step-before"),
    transform(filter="datum.series=='Agriculture'"),
    transform(),
    encoding(x_(timeUnit="yearmonth", field="date", type_="temporal",
               scale_(nice="month"),
               axis(format="%Y", labelAngle=-45)),
             y_(aggregate="sum", field="count", type_="quantitative"),
             color_(field="series", type_="nominal", scale_(scheme="category20b"))
            )
    )

############################################################################

using DataFrames

df  = DataFrame(x=[1:7;], y=rand(7))
dfd = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]

encx = x_(field=:x, type_="quantitative")
ency = y_(field=:y, type_="quantitative")

plot(data(values_ = dfd), width=500,
    #  transform(as=:o, calculate="datum.x * 2"),
     layer(mark_(type_="line"), encoding(encx, ency, color_(value="green"))),
     layer(mark_(type_="line", interpolate="cardinal"),
           encoding(encx, ency, color_(value="blue"))),
     layer(mark_(type_="line", interpolate="basis"),
           encoding(encx, ency, color_(value="red"))),
     layer(mark_ = "point",
           encoding(encx, ency,
                    color_(value="black"),
                    size_(value=50)))
   )


###########################################################################

r, nb = 5., 10
df = DataFrame(n = [1:nb;],
               x = r * (0.2 + rand(nb)) .* cos.(2π * linspace(0,1,nb)),
               y = r * (0.2 + rand(nb)) .* sin.(2π * linspace(0,1,nb)))

dfd = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]

encx = x_(field=:x, type_="quantitative", scale_(zero=false))
ency = y_(field=:y, type_="quantitative", scale_(zero=false))
encn = order_(field=:n, type_="quantitative", scale_(zero=false))

plot(data(values_ = dfd),
     layer(mark_(type_="line", interpolate="basis-closed"),
           encoding(encx, ency, encn, color_(value="blue"))),
     layer(mark_ = "point",
           encoding(encx, ency,
                    color_(value="black"),
                    size_(value=50)))
 )


values_

JSON.json(df)

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
 format


###########################################################################

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/population.json"

xchan = x_(field="age", type_="ordinal", axis(labelAngle=-45))
ychan = y_(field="people", type_="quantitative")

ymin = y_(aggregate="min", field="people", type_="quantitative",
         axis(title="population"))
ymax = y_(aggregate="max", field="people", type_="quantitative",
        axis(title="population"))
y2max = y2_(aggregate="max", field="people", type_="quantitative",
        axis(title="population"))
ymean = y_(aggregate="mean", field="people", type_="quantitative",
                axis(title="population"))

line
plot(data(url=durl),
     transform=[ Dict(filter => "datum.year==2000")],
     layer(mark="tick",  encoding(xchan, ymin, size_(value=5))),
     layer(mark="tick",  encoding(xchan, ymax, size_(value=5))),
     layer(mark="point", encoding(xchan, ymean, size_(value=5))),
     layer(mark="rule",  encoding(xchan, ymin, y2max))
     )

plot(data(url=durl),
    transform(filter = "datum.year==2000"),
    transform(),
    layer(mark="tick",  encoding(xchan, ymin, size_(value=5))),
    layer(mark="tick",  encoding(xchan, ymax, size_(value=5))),
    layer(mark="point", encoding(xchan, ymean, size_(value=5))),
    layer(mark="rule",  encoding(xchan, ymin, y2max))
    )

plot(data(url=durl),
    transform(filter = "datum.year==2000"),
    transform(),
    vconcat(hconcat(mark="tick",  encoding(xchan, ymin, size_(value=5))),
            hconcat(mark="tick",  encoding(xchan, ymax, size_(value=5)))),
    vconcat(hconcat(mark="point", encoding(xchan, ymean, size_(value=5))),
            hconcat(mark="rule",  encoding(xchan, ymin, y2max)))
    )
# marche pas pourquoi ?

plot(data(url=durl),
     layer(mark="point", encoding(xchan, ychan)),
     layer(mark="line",  encoding(xchan, ymean)),
     width=800, height=600
    )

y_

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
