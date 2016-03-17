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


##################### Atom.plotpane  #######################



using VegaLite
using Media, Atom
import Media: render


####
using Gadfly
vt = plot(x=rand(10), y=rand(10));nothing

typeof(vt)
Base.Multimedia.displays
Media.getdisplay(typeof(vt))


#####

ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

v = data_values(time=ts, res=ys) +
      mark_line() +
      encoding_x_quant(:time) +
      encoding_y_quant(:res); nothing

typeof(v)

media(VegaLiteVis, Media.Graphical)
getdisplay(typeof(v))
getdisplay(Atom.Media.Graphical)

function render(::Atom.PlotPane, v::VegaLiteVis)
  io = IOBuffer()
  VegaLite.writehtml(io, v)
  stringmime("text/html",takebuf_string(io))
end


I confirm it is still on my todo list.

It doesn't seem to me to be big enough for a GSoC though, but I don't know much about the kind of projects that are typical.

While we are at it: there are two ways I can think of to indicate that we do not want to differentiate with respect to one or several of the variables : 1) add an option to `rdiff` to indicate those variables or 2) require the user to build a closure setting the values of the variable and ask `rdiff` to find the value in the function environment.

Solution 1) seems more generic and require less efforts from the user. Is this what you also had in mind ?


v


#####

type Eurghh ; end
typeof(v)

media(Eurghh, Media.Graphical)
getdisplay(Eurghh)
getdisplay(Atom.Media.Graphical)

function render(::Atom.PlotPane, ::Eurghh)
  HTML(stringmime("text/html", "<div>abcd</div>"))
end

Eurghh
Eurghh()

result=Eurghh()
let Media.input = Editor()
  println(Media.getdisplay(typeof(result), default = Atom.Editor()) )
  # display ≠ Editor() && render(display, result)
  # render(Editor(), result)
end

# @require Gadfly begin
#   @render PlotPane p::Gadfly.Plot begin
#     x, y = Atom.@rpc Atom.plotsize()
#     Gadfly.set_default_plot_size(x*Gadfly.px, y*Gadfly.px)
#     div(d(:style=>"background: white"),
#         HTML(stringmime("text/html", p)))
#   end
# end

end

end
