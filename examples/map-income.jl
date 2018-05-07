using VegaLite
using NamedTuples

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
