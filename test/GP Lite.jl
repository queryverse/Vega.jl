module A ; end
reload("VegaLite")
reload("Paper")


module A
using Paper
using VegaLite
import JSON

@session GPLite vbox pad(2em)

@rewire Vega.VegaVisualization

sleep(3.0)
vv = Paper.currentSession.window
push!(vv.assets, ("VegaLite", "vega-lite"))

#-------- draw the header ----------------------------------
@newchunk header vbox packacross(center) fillcolor("#ddd") pad(1em)

title(2, "Veg Lite")
title(1, "with plots using VegaLite") |> fontstyle(italic)

#------- plot ------------------------------------
@newchunk center

  xs = collect(linspace(0., 1., 200))


visjs = """
  {
    "description": "A simple bar chart with embedded data.",
    "data": {
      "values": [
        {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
        {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
        {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
      ]
    },
    "mark": "bar",
    "encoding": {
      "x": {"field": "a", "type": "ordinal"},
      "y": {"field": "b", "type": "quantitative"}
    }
  }
  """


VegaLite.VegaLiteTile(visjs)


@newchunk center2

VegaLite.VegaLiteTile(visjs)
