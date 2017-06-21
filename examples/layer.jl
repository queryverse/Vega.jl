using DataTables, VegaLite

# Example 1 : interpolation mode comparisons

df  = DataFrame(x=[0:5;], y=rand(6))

encx = xquantitative(field=:x)
ency = yquantitative(field=:y)

df |>
  plot(width=500) |>
  layer(markline(interpolate="linear"),
        encoding(encx, ency, vlcolor(value="green"))) |>
  layer(markline(interpolate="basis"),
        encoding(encx, ency, vlcolor(value="red"))) |>
  layer(markpoint(), encoding(encx, ency, vlcolor(value="black")))


# Example 2 : closed shape w/ points

r, nb = 5., 10
df = DataFrame(n = [1:nb;],
               x = r * (0.2 + rand(nb)) .* cos.(2π * linspace(0,1,nb)),
               y = r * (0.2 + rand(nb)) .* sin.(2π * linspace(0,1,nb)))

encx = xquantitative(field=:x, vlscale(zero=false))
ency = yquantitative(field=:y, vlscale(zero=false))
encn = orderquantitative(field=:n)

df |>
  layer(markpoint(),
        encoding(encx, ency, vlcolor(value="black"), vlsize(value=50))) |>
  layer(markline(interpolate="cardinal-closed"),
        encoding(encx, ency, encn, vlcolor(value="green")))


# Example 3 : error bars

rooturl = "https://raw.githubusercontent.com/vega/new-editor/master/"
durl = rooturl * "data/population.json"

xchan = xordinal(field=:age, vlaxis(labelAngle=-45))
ychan = yquantitative(field=:people)

tpop = vlaxis(title="population")
ymin = yquantitative(aggregate=:min, field=:people, tpop)
ymax = yquantitative(aggregate=:max, field=:people, tpop)
y2max = y2quantitative(aggregate=:max, field=:people)
ymean = yquantitative(aggregate=:mean, field=:people, tpop)

VegaLite.data(url=durl) |>
  transform(filter="datum.year==2000") |>
  layer(marktick(),  encoding(xchan, ymin, vlsize(value=5))) |>
  layer(marktick(),  encoding(xchan, ymax, vlsize(value=5))) |>
  layer(markpoint(), encoding(xchan, ymean, vlsize(value=5))) |>
  layer(markrule(),  encoding(xchan, ymin, y2max))
