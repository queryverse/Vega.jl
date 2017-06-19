using VegaLite

src = "https://raw.githubusercontent.com/vega/new-editor/master/data/movies.json"

# Syntax 1 : using vl.. functions

plot(vldata(url=src),
     vlmark(typ=:circle),
     vlencoding(
        vlx(typ=:quantitative, vlbin(maxbins=10), field=:IMDB_Rating),
        vly(typ=:quantitative, vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
        vlsize(typ=:quantitative, aggregate=:count))
    )



# Syntax 2 : using pipes and shorcut functions

VegaLite.data(url=src) |>
  markcircle() |>
  encoding(xquantitative(vlbin(maxbins=10), field=:IMDB_Rating),
           yquantitative(vlbin(maxbins=10), field=:Rotten_Tomatoes_Rating),
           sizequantitative(aggregate=:count))
