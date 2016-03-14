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

buttons(false)
svg(false)

@newchunk center2 hbox
@newchunk center2.nw hbox

container(10em,10em) |> fillcolor("#daa")
hline() |> fillcolor("#daa")
vskip(1em)

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
  encoding_y_quant(:Hwy, scale=scale(zero=false)) +
  encoding_color_nominal(:Manufacturer) +
  config_cell(width=350, height=400)

data_values(mpg) +
  mark_line() +
  encoding_x_ord(:Year,
                 axis  = axis(labelAngle=-45, labelAlign="right"),
                 scale = scale(bandSize=50)) +
  encoding_y_quant(:Hwy, aggregate="mean") +
  encoding_color_nominal(:Manufacturer)

data_values(mpg) +
  mark_point() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_x_quant(:Displ) +
  encoding_y_quant(:Hwy) +
  encoding_size_quant(:Cty) +
  encoding_color_nominal(:Manufacturer)

data_values(mpg) +
  mark_text() +
  encoding_column_ord(:Cyl) +
  encoding_row_ord(:Year) +
  encoding_text_quant(:Displ, aggregate="mean") +
  config_mark(fontStyle="italic", fontSize=12, font="courier")


##################### IJulia   #######################

Pkg.build("IJulia")
Pkg.build("IJulia")
Pkg.build("IJulia")

using IJulia
@async notebook()

using SHA
sha256("abcde")
5+6

WARNING:root:kernel 6e1e5e58-776c-4d0e-b9e2-0d934ff40742 restarted
WARNING: Union(args...) is deprecated, use Union{args...} instead.
 in depwarn at deprecated.jl:73
 in call at deprecated.jl:50
 in include at boot.jl:261
 in include_from_node1 at loading.jl:304
 in include at boot.jl:261
 in include_from_node1 at loading.jl:304
 in include at boot.jl:261
 in include_from_node1 at loading.jl:304
 in process_options at client.jl:280
 in _start at client.jl:378
while loading D:\frtestar\.julia\v0.4\IJulia\src\handlers.jl, in expression starting on line 49
ERROR: LoadError: UndefVarError: SHA256 not defined
 in init at D:\frtestar\.julia\v0.4\IJulia\src\IJulia.jl:62
 in include at boot.jl:261
 in include_from_node1 at loading.jl:304
 in process_options at client.jl:280
 in _start at client.jl:378
while loading D:\frtestar\.julia\v0.4\IJulia\src\kernel.jl, in expression starting on line 6
[I 14:40:00.311 NotebookApp] KernelRestarter: restarting kernel (1/5)

using Nettle

signature_scheme = "hmac-sha256"
isempty(signature_scheme) && (signature_scheme = "hmac-sha256")
signature_scheme = split(signature_scheme, "-")
if signature_scheme[1] != "hmac" || length(signature_scheme) != 2
    error("unrecognized signature_scheme")
end
global const hmacstate = HMACState(eval(symbol(uppercase(signature_scheme[2]))),
                            profile["key"])


HMACState(uppercase(signature_scheme[2]), "abcd")
import IJulia
whos(IJulia)
