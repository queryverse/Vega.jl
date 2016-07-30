
asset(url...) = @compat readstring(joinpath(dirname(@__FILE__), "..", "assets", "bower_components", url...))

#Vega Scaffold: https://github.com/vega/vega/wiki/Runtime
function writehtml(io::IO, v::VegaLiteVis; title="Vega.jl Visualization")
  d3          = asset("d3","d3.min.js")
  vega        = asset("vega", "vega.js")
  vegalite    = asset("vega-lite", "vega-lite.js")
  vegaembed   = asset("vega-embed", "vega-embed.js")

  divid = "vg" * randstring(3)

  println(io,
  """
  <html>
    <head>
      <title>$title</title>
      <script>$d3</script>
      <script>$vega</script>
      <script>$vegalite</script>
      <script>$vegaembed</script>

    </head>
    <body>
      <div id="$divid"></div>
    </body>

  <script type="text/javascript">

  var embedSpec = {
    mode: "vega-lite",
    renderer: "$(SVG ? "svg" : "canvas")",
    actions: $SAVE_BUTTONS,
    spec: $(JSON.json(v.vis))
  }

  vg.embed("#$divid", embedSpec, function(error, result) {
    result.view.renderer("svg")
  });

  </script>


  </html>
  """)
end

function show(io::IO, v::VegaLiteVis)

    if displayable("text/html")
        v
    else
        # create a temporary file
        tmppath = string(tempname(), ".vegalite.html")
        io = open(tmppath, "w")
        writehtml(io, v)
        close(io)

        # Open the browser
        @osx_only     run(`open $tmppath`)
        @windows_only run(`cmd /c start $tmppath`)
        @linux_only   run(`xdg-open $tmppath`)
    end

    return
end

###################################################


# asset(url...) = readall(Pkg.dir("Vega", "assets", "bower_components", url...))

# function writemime(io::IO, ::MIME"text/html", v::VegaVisualization)
#     divid = "vg" * randstring(3)
#     script_contents = scriptstr(v, divid)
#     display("text/html", """
#     <body>
#     <div id=\"$divid\"></div>
#     </body>
#     <script type="text/javascript">
#         $script_contents
#     </script>
#     """)
# end
#
# import Patchwork: Elem

# function patchwork_repr(v::VegaLiteVis)
#     divid = "vg" * randstring(3)
#     script_contents = scriptstr(v, divid)
#     Elem(:div, [
#         Elem(:div, "") & Dict(:id=>divid, :style=>Dict("min-height"=>"$(v.height + 110)px")),
#         Elem(:script, script_contents) & Dict(:type=>"text/javascript")
#     ])
# end

# function writemime(io::IO, m::MIME"text/html", v::VegaLiteVis)
#
#
#   fh = """
#   <div>
#     <script src="bower_components/d3/d3.min.js" charset="utf-8"></script>
#     <script src="bower_components/vega/vega.js" charset="utf-8"></script>
#     <script src="bower_components/vega-lite/vega-lite.js" charset="utf-8"></script>
#     <script src="bower_components/vega-embed/vega-embed.js" charset="utf-8"></script>
#
#     <dom-module id="vega-lite-plot">
#       <template>
#         <div>
#             <content></content>
#         </div>
#       </template>
#       <script>
#         Polymer({
#           is: "vega-lite-plot",
#           properties: {
#             json: {
#               type: Object,
#               notify: true,
#               observer: 'render'
#             },
#             svg: Boolean,
#             actions: Boolean
#           },
#
#           render: function() {
#             var embedSpec = {
#               mode: "vega-lite",
#               renderer: this.svg ? "svg" : "canvas",
#               actions: false, //this.actions,
#               spec: this.json
#             }
#             vg.embed(this, embedSpec, function(error, result) {
#             });
#
#           },
#
#           attached: function (){
#             this.render()
#           },
#
#         });
#       </script>
#     </dom-module>
#
#     <vega-lite-plot json="$(v.vis)" svg ></vega-lite-plot>
#
#   </div>
#   """
#
#   # writemime(io, m, fh)
#   write(io, fh)
# end

# function jslibpath(url...)
#   libpath = joinpath(dirname(@__FILE__), "..", "assets", "bower_components", url...)
#   replace(libpath, "\\", "/")  # for windows...
# end
#
#
# function writemime(io::IO, m::MIME"text/html", v::VegaLiteVis)
#   divid = "vl" * randstring(3) # generated id for this plot

#   script = """
#     require.config({
#       paths: {
#         d3:        "https://d3js.org/d3.v3.min",
#         vega:      "https://vega.github.io/vega/vega.min",
#         vegalite:  "https://vega.github.io/vega-lite/vega-lite",
#         vegaembed: "https://vega.github.io/vega-editor/vendor/vega-embed"
#       }
#     });
#
#     require(["d3"], function(d3){
#
#       window.d3 = d3;
#
#       require(["vega", "vegalite", "vegaembed"],
#              function(vg, vgl, vge){
#
#         // window.vg = vg;
#
#         vg.parse.spec({
#   "description": "A simple bar chart with embedded data.",
#   "data": {
#     "values": [
#       {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
#       {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
#       {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
#     ]
#   },
#   "mark": "bar",
#   "encoding": {
#     "x": {"field": "a", "type": "ordinal"},
#     "y": {"field": "b", "type": "quantitative"}
#   }
# }, function(chart) { chart({el:"#$divid"}).update(); });
#
#         document.getElementById("$divid").insertAdjacentHTML('beforeend', '<br><a >Save yourgh ! as PNG</a>')
#
#
#       });
#     });
#   """
#
#   spec = """
#   {
#     "width": 400,
#     "height": 200,
#     "padding": {"top": 10, "left": 30, "bottom": 30, "right": 10},
#     "data": [
#       {
#         "name": "table",
#         "values": [
#           {"x": 1,  "y": 28}, {"x": 2,  "y": 55},
#           {"x": 3,  "y": 43}, {"x": 4,  "y": 91},
#           {"x": 5,  "y": 81}, {"x": 6,  "y": 53},
#           {"x": 7,  "y": 19}, {"x": 8,  "y": 87},
#           {"x": 9,  "y": 52}, {"x": 10, "y": 48},
#           {"x": 11, "y": 24}, {"x": 12, "y": 49},
#           {"x": 13, "y": 87}, {"x": 14, "y": 66},
#           {"x": 15, "y": 17}, {"x": 16, "y": 27},
#           {"x": 17, "y": 68}, {"x": 18, "y": 16},
#           {"x": 19, "y": 49}, {"x": 20, "y": 15}
#         ]
#       }
#     ],
#     "scales": [
#       {
#         "name": "x",
#         "type": "ordinal",
#         "range": "width",
#         "domain": {"data": "table", "field": "x"}
#       },
#       {
#         "name": "y",
#         "type": "linear",
#         "range": "height",
#         "domain": {"data": "table", "field": "y"},
#         "nice": true
#       }
#     ],
#     "axes": [
#       {"type": "x", "scale": "x"},
#       {"type": "y", "scale": "y"}
#     ],
#     "marks": [
#       {
#         "type": "rect",
#         "from": {"data": "table"},
#         "properties": {
#           "enter": {
#             "x": {"scale": "x", "field": "x"},
#             "width": {"scale": "x", "band": true, "offset": -1},
#             "y": {"scale": "y", "field": "y"},
#             "y2": {"scale": "y", "value": 0}
#           },
#           "update": {
#             "fill": {"value": "steelblue"}
#           },
#           "hover": {
#             "fill": {"value": "red"}
#           }
#         }
#       }
#     ]
#   }
#   """
#
#   spec2 = """
#   {
#     "description": "A simple bar chart with embedded data.",
#     "data": {
#       "values": [
#         {"a": "A","b": 28}, {"a": "B","b": 55}, {"a": "C","b": 43},
#         {"a": "D","b": 91}, {"a": "E","b": 81}, {"a": "F","b": 53},
#         {"a": "G","b": 19}, {"a": "H","b": 87}, {"a": "I","b": 52}
#       ]
#     },
#     "mark": "bar",
#     "encoding": {
#       "x": {"field": "a", "type": "ordinal"},
#       "y": {"field": "b", "type": "quantitative"}
#     }
#   }
#   """
#
#   script = """
#         require.config({
#           paths: {
#             d3: "https://vega.github.io/vega-editor/vendor/d3.min",
#             vega: "https://vega.github.io/vega/vega.min",
#             cloud: "https://vega.github.io/vega-editor/vendor/d3.layout.cloud",
#             topojson: "https://vega.github.io/vega-editor/vendor/topojson",
#             vegalite: "https://vega.github.io/vega-lite/vega-lite",
#             embed: "https://vega.github.io/vega-editor/vendor/vega-embed"
#           }
#         });
#
#         require(["d3", "topojson", "cloud"], function(d3, topojson, cloud){
#
#           window.d3 = d3;
#           window.topojson = topojson;
#           window.d3.layout.cloud = cloud;
#           console.log("d3")
#
#
#             require(["vega"], function(vg) {
#
#               window.vg = vg
#               console.log("vg")
#
#               require(["vegalite"], function(vgl) {
#
#                 console.log("vegalite")
#
#                 var embedSpec = {
#                   renderer: "svg",
#                   actions: false,
#                   spec: $spec2
#                 };
#
#                 var vgSpec = vgl.compile(embedSpec.spec).spec;
#                 vg.parse.spec(vgSpec, function(chart) { chart({el:\"#$divid\"}).update(); });
#
#               }); //vegaembed require end
#             }); //vega require end
#
#         }); //d3 require end
#     """
    # vg.embed("#$divid", embedSpec, function(error, result) { });
    # vg.parse.spec($spec, function(chart) { chart({el:\"#$divid\"}).update(); });


    # window.setTimeout(function() {
    # var pnglink = document.getElementById(\"$divid\").getElementsByTagName(\"canvas\")[0].toDataURL(\"image/png\")
    # document.getElementById(\"$divid\").insertAdjacentHTML('beforeend', '<br><a href=\"' + pnglink + '\" download>Save as PNG</a>')
    #
    # }, 20);

  # var vgSpec = vgl.compile(embedSpec.spec).spec;
  # var embedSpec = {
  # mode: "vega-lite",
  # renderer: "svg",
  # actions: false,
  # spec: $(JSON.json(v.vis))
  # };
  #
  # vg.embed("#$divid", embedSpec, function(error, result) { result.view });

  # patch = Elem(:div, [
  #             Elem(:div, "") & Dict(:id=>divid, :style=>Dict("min-height"=>"300px")),
  #             # Elem(:div, "") & Dict(:id=>divid),
  #             Elem(:script, script) & Dict(:type=>"text/javascript")
  #         ])
  #
  # return writemime(io, m, patch)


  # fh = """
  # <div>
  #   <script src="$(jspath("d3","d3.min.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega", "vega.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega-lite", "vega-lite.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega-embed", "vega-embed.js"))" charset="utf-8"></script>

  # // d3: "$(jslibpath("d3","d3.min.js"))",
  # // vega: "$(jslibpath("vega", "vega.js"))",
  # // vegalite: "$(jslibpath("vega-lite", "vega-lite.js"))",
  # // vegaembed: "$(jslibpath("vega-embed", "vega-embed.js"))"
#
#   fh = """
#   <div>
#     <div id="$divid"></div>
#
#     <meta charset="utf-8">
#
#     <script type="text/javascript">
#       require.config({
#         paths: {
#           d3:        "https://d3js.org/d3.v3.min",
#           vega:      "https://vega.github.io/vega/vega",
#           vegalite:  "https://vega.github.io/vega-lite/vega-lite",
#           vegaembed: "https://vega.github.io/vega-editor/vendor/vega-embed"
#         }
#       });
#
#       require(["d3"], function(d3){
#
#         window.d3 = d3;
#         console.log("d3")
#
#         require(["vega"], function(vg) {
#
#           window.vg = vg
#           console.log("vg")
#
#           require(["vegalite"], function(vgl) {
#
#             console.log("vegalite")
#
#             var embedSpec = {
#               mode: "vega-lite",
#               renderer: "svg",
#               actions: false,
#               spec: $(JSON.json(v.vis))
#             }
#
#             var vgSpec = vgl.compile(embedSpec.spec).spec;
#             vg.parse.spec(vgSpec, function(chart) { chart({el:\"#$divid\"}).update(); });
#
#           }); //vegaembed require end
#         }); //vega require end
#       }); //d3 require end
#
#     </script>
#
#   </div>
#   """
#   # FIXME : understand why vega-embed can't be loaded
#   # vg.embed("#$divid", embedSpec, function(error, result) {
# 
#   println(fh)
#   # writemime(io, m, fh)
#   write(io, fh)
# end
#
#
# export writemime
