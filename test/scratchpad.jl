
reload("VegaLite")

module VegaLite
methods(VLSpec)
VLSpec{:vlmark}(typ=:point).params
VLSpec{:vlmark}(typo=:point).params
VLSpec{:vlmark}(Dict("typ" => :point)).params

VLSpec{:vllayer}(mark=@NT(typ=:point),
                 encoding=@NT(x=@NT(typ=:nominal, field=:xx)),
                 width=300).params
VLSpec{:vllayer}(encoding=@NT(x=@NT(typ=:nominal, field=:xx)),
                 width=300).params

VLSpec{:vllayer}(VLSpec{:vlencoding}(x=@NT(typ=:nominal, field=:xx)),
                 VLSpec{:vlmark}(typ=:point),
                 width=300).params

todicttree(VLSpec{:vlencoding}(x=@NT(typ=:nominal, field=:xx)),
                 VLSpec{:vlmark}(typ=:point),
                 width=300)

ttt = VLSpec{:vllayer}(encoding=@NT(x=@NT(typ=:nominal, field=:xx)),
                 width=300);


dim, typ = :x, :nominal
ttt = eval(quote
    (val, args...; kwargs...) ->
        VLSpec{:vlencoding}(;$dim = todicttree(args...;field=val, typ= :($typ), kwargs...))
    end)

ttt(:xx).params

dump( :( ( val, args... ; kwargs... ) -> 12 ) )

macro mkfuncEDT(dim, typ)
    quote
        function abcd( val, args... ; kwargs... )
            # println(val, ",", args, ",", kwargs)
            VLSpec{:vlencoding}(;$dim = todicttree(args...;field=val, typ=:($typ), kwargs...))
        end
    end
end

println( macroexpand( @mkfuncEDT(x, nominal) ) )

ttt = @mkfuncEDT(x, nominal)
ttt(:x, axis=nothing).params

macro mkfuncEDT(dim, typ)
    fn = gensym()
    if typ == :value
        quote
            function ($fn)(val, args...; kwargs...)
                VLSpec{:vlencoding}(;$dim = todicttree(args...;value=val, typ=:($typ), kwargs...))
            end
        end
    else
        quote
            function ($fn)(val, args...; kwargs...)
                VLSpec{:vlencoding}(;$dim = todicttree(args...;field=val, typ=:($typ), kwargs...))
            end
        end
    end
end

ttt = @mkfuncEDT(x, nominal)

channels = Symbol.(collect(keys(refs["EncodingWithFacet"].props)))
chantyps = Symbol.(collect(union(refs["BasicType"].enum, refs["GeoType"].enum)))
push!(chantyps, :value)

typnt = NamedTuples.make_tuple( chantyps )

encs = []
ch, tp = :x, :nominal
for ch in channels
    typs = []
    for tp in chantyps
        fn = gensym()
        nfex = quote
                function ($fn)(val, args...; kwargs...)
                    VLSpec{:vlencoding}(;$ch = todicttree(args...; field=val, typ=:($tp), kwargs...))
                end
               end
        push!(typs, eval(nfex))
    end
    push!(encs, typnt( typs... ) )
end
ch
encnt = NamedTuples.make_tuple( channels )
enc = encnt( encs... )

enc.x.value(:abd, axis=nothing)
println(nfex)

typnt = eval( :( @NT $chantyps ) )
typeof(typnt)

clipboard(union(refs["BasicType"].enum, refs["GeoType"].enum))
Set(String["geojson", "latitude", "ordinal", "nominal", "longitude", "quantitative", "temporal"])

typtype = @NT(:geojson, :latitude, :ordinal, :nominal, :longitude, :quantitative, :temporal )

typtype =

refs["EncodingWithFacet"].props


ttt(:yoyo, axis=nothing).params


ttt = @NT( [ (:nominal,      mkfuncEDT(:vlx, :nominal)),
       (:quantitative, mkfuncEDT(:vlx, :quantitative))]... )

tlst = [:nominal, :quantitative, :ordinal, :temporal, :value]
ttt = @NT(nominal, quantitative, ordinal, temporal, value)
tmp = ttt([mkfuncEDT(:vlx, t) for t in tlst]...)


ttt = VLSpec{:vlx}(field=:yoyo, typ=:nominal, axis=nothing);
tt2 = VLSpec{:vlencoding}(Dict(:x => ttt.params));
tt2 = VLSpec{:vlencoding}(ttt);
tt2.params
vltype(ttt)
vlname(vltype(ttt))



ttt = tmp.nominal(:yoyo, axis=nothing);
ttt.params



ttt = VLSpec{:vlx}(typ=:nominal, field = :k);
ttt.params

tt2 = VLSpec{:vlencoding}(ttt);
tt2.params

tmp.nominal(field = :k)


methods(VLSpec)

p = res |>
    plot(mark.bar(),
         encoding.x.nominal(:src),
         encoding.y.quantitative(:val),
         encoding.color.nominal(:src),
         encoding.column.nominal(:cat),
         height=400, width=80);

end



module A

using VegaLite

############################################################

durl = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

p = plot(vldata(url=durl),
     mark="circle",
     vlencoding(vlx(vlbin(maxbins=10), field=:IMDB_Rating, typ=:quantitative),
                vly(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating, typ=:quantitative),
                vlsize(aggregate=:count, typ=:quantitative)),
     width=300, height=300) ;

p

pdf("c:/temp/ex.pdf", p)



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
  markcircle() |>
  vlencoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
             yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
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

vlfilter

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

data(dt) |>
  repeat(column = [:a, :b, :c], row = [:a, :b, :c]) |>
  spec(markpoint() |>
       encoding(xquantitative(vlfield(repeat=:column)),
                yquantitative(vlfield(repeat=:row))))

dt |>
  repeat(column = [:a, :b, :c], row = [:a, :b, :c]) |>
  spec(markpoint() |>
       encoding(xquantitative(vlfield(repeat=:column)),
                yquantitative(vlfield(repeat=:row))))


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
