module A ; end
reload("VegaLite")
reload("Atom")
reload("Media")
reload("Paper")


module A
using Paper
using VegaLite
import JSON


@session vgtest vbox pad(2em)

@rewire VegaLite.VegaLiteVis
show("abcd")

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

vals = rand(['1':'9';'-'],81)
vals = [ string(rand(['1':'9';'-'])) for i in 1:81]
data_values(x   = repeat([1:9],outer=[9]),
            y   = repeat([1:9],inner=[9]),
            val = vals) +
  mark_text() +
  encoding_column_ord(:x) +
  encoding_row_ord(:y) +
  encoding_text_quant(:val) +
  config_mark(fontSize=16, font="calibri", format="0d")

collect("1":"9")


##################### Atom.plotpane  #######################

using VegaLite

####
import Gadfly
vt = Gadfly.plot(x=rand(10), y=rand(10))
vt
typeof(vt)
Base.Multimedia.displays

import Media
Media.getdisplay(typeof(vt))

Media.media(Gadfly.Plot, Media.Plot)


show(vt)

using Media, Atom
import Media: render
import Atom

function render(::Atom.PlotPane, p::Gadfly.Plot)
  x, y = Atom.@rpc plotsize()
  println("render plot")
  Gadfly.set_default_plot_size(x*Gadfly.px, y*Gadfly.px)
  Atom.div(Atom.d(:style=>"background: white"),
        Atom.HTML(stringmime("text/html", p)))
  # Atom.div(Dict{Any,Any}(:style=>"background: blue"),
          #  Atom.HTML("coucou"))
end

vt

Atom.Abcd()

type Abcd; end

import Media.media
Media.media(::Abcd) = Media.Graphical()
Media.media(Abcd, Media.Plot)

Media.getdisplay(Abcd)
Media.getdisplay(Gadfly.Plot)
Media.getdisplay(Media.Graphical)

function render(::Atom.PlotPane, x::Abcd)
  x, y = Atom.@rpc plotsize()
  println("render Abcd")
  Atom.div(Dict{Any,Any}(:style=>"background: blue"),
           Atom.HTML("coucou"))
end

Abcd()
A.Abcd()


Media.render(Atom.Inline(), Abcd())
methods(Media.render, (Any, Gadfly.Plot))
methods(Media.render, (Atom.PlotPane, Any))

Atom.@render PlotPane x::Abcd begin
  # x, y = @rpc plotsize()
  # println(x,y)
  # div(Dict{Any,Any}(:style=>"background: black"),
  #     HTML(stringmime("text/html", "coucou")))
end


using VegaLite
import Media, Atom
Media.media(VegaLite.VegaLiteVis, Media.Plot)

methods(Media.render, (Atom.PlotPane, Any))





ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

v = data_values(time=ts, res=ys) +
      mark_line() +
      encoding_x_quant(:time) +
      encoding_y_quant(:res)
v

@require VegaLite begin
  @render PlotPane v::VegaLite.VegaLiteVis begin
    HTML() do io
      print(io, """
      <div>
      <div id="vegaliteplot">aaaaaaaaa</div>

    <script type="text/javascript">
      document.getElementById("vegaliteplot").value = "zzzz"
      console.log("was here !")

    </script>

      $(JSON.json(v.vis))
      </div>
      """)
    end
    # x, y = @rpc plotsize()
    # Gadfly.set_default_plot_size(x*Gadfly.px, y*Gadfly.px)
    # println("plotpane - VegaLiteVis")
    # tmppath = string(tempname(), ".vegalite.html")
    # io = open(tmppath, "w")
    # VegaLite.writehtml(io, v)
    # seek(io,0)
    # readall(io)
  end
end



########## new style  ##############

function testf(a, bs...; ks...)
  println("a = $a")
  println("bs = $bs")
  println("ks = $ks")
end

testf(45, tt=:sdf)
testf(45, "sss", tt=:sdf)
testf(45, tt=:sdf, "qsdq")
testf(45, tt=:sdf)
