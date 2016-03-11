module A ; end
reload("VegaLite")
reload("Paper")


module A
using Paper
using VegaLite
import JSON


# config(abcd="trus")
# config(viewport="trus")
# config(viewport=[400,330])
# JSON.json(v.vis)

@session vgtest vbox pad(2em)

@rewire VegaLite.VegaLiteVis

sleep(3.0)
vv = Paper.currentSession.window
push!(vv.assets, ("VegaLite", "vega-lite"))

#-------- draw the header ----------------------------------
@newchunk pg vbox packacross(center) fillcolor("#ddd") pad(1em)

title(2, "Veg Lite")
title(1, "with plots using VegaLite") |> fontstyle(italic)

#------- plot ------------------------------------
@newchunk center


ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

v = data_values(time=ts, res=ys) +
      mark_line() +
      encoding_x_quant(:time) +
      encoding_y_quant(:res)

v2 = v + config_scale(round=true)
JSON.print(v2.vis)


v2 = v + config_axis(axisWidth=3.2, labelAngle=45)
v2 = v + config_axis(labelAlign="left")
v2 = v + config_axis(tickPadding=10)
JSON.print(v2.vis)



v = data_values(time=[ts, reverse(ts)], res=[ys, reverse(ys-0.3)]) +
  mark_area() +
  encoding_x_quant(:time) +
  encoding_y_quant(:res) +
  # encoding_path_quant() +
  config_cell(width=300, height=300)

v |> fontstyle(italic)

data_values(posit=[1:2length(ts);], time=[ts, reverse(ts)], res=[ys, reverse(ys-0.3)]) +
  mark_line() +
  encoding_x_quant(:time, scale=Dict(:domain=>[0,1])) +
  encoding_y_quant(:res) +
  encoding_path_ord(:posit) +
  config(background="#eee") +
  config_grid(gridColor="green") +
  config_mark(font="Courrier New", strokeDash=[5,5], stroke="red",
              filled=true, fill="#8e8", fillOpacity=0.2) +
  config_cell(width=200, height=150, strokeWidth=.2, strokeDash=[10,5])


JSON.print(data_values(posit=[1:2length(ts);], time=[ts, reverse(ts)], res=[ys, reverse(ys-0.3)]))

@newchunk rdataset

using RDatasets

mpg = dataset("ggplot2", "mpg")


data_values(mpg) +
  mark_point() +
  encoding_x_quant(:Cty) +
  encoding_y_quant(:Hwy)

data_values(mpg) +
  mark_point() +
  encoding_x_quant(:Cty, axis=false) +
  encoding_y_quant(:Hwy) +
  encoding_color_nominal(:Manufacturer)

data_values(mpg) +
  mark_line() +
  encoding_x_ord(:Year,
                 axis  = Dict(:labelAngle=>-45, :labelAlign=>"right"),
                 scale = Dict(:bandSize=>50)) +
  encoding_y_quant(:Hwy, aggregate="mean") +
  encoding_color_nominal(:Manufacturer)


data_values(mpg) +
  mark_point() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_x_quant(:Displ) +
  encoding_y_quant(:Hwy) +
  encoding_color_nominal(:Manufacturer)

  {
    "data": {"url": "data/cars.json"},
    "mark": "text",
    "encoding": {
      "row": {"field": "Origin", "type": "ordinal"},
      "column": {"field": "Cylinders", "type": "ordinal"},
      "color": {"aggregate": "mean", "field": "Horsepower", "type": "quantitative"},
      "text": {"aggregate": "count", "field": "*", "type": "quantitative"}
    },
    "config": {"mark": {"applyColorToBackground": true}}
  }
