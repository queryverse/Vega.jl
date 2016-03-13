
asset(url...) = @compat readstring(Pkg.dir("VegaLite", "assets", "bower_components", url...))

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

import Base.writemime

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
import Patchwork: Elem

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

jspath(url...) = Pkg.dir("VegaLite", "assets", "bower_components", url...)

function writemime(io::IO, m::MIME"text/html", v::VegaLiteVis)
  # fh = """
  # <div>
  #   <script src="$(jspath("d3","d3.min.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega", "vega.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega-lite", "vega-lite.js"))" charset="utf-8"></script>
  #   <script src="$(jspath("vega-embed", "vega-embed.js"))" charset="utf-8"></script>

    fh = """
    <div>

    <div id="plot">
      <content></content>
    </div>



    <script type="text/javascript">

      require.config({
        paths: {
          d3: "$(jspath("d3","d3.min.js"))",
          vega: "$(jspath("vega", "vega.js"))",
          vegalite: "$(jspath("vega-lite", "vega-lite.js"))",
          vegaembed: "$(jspath("vega-embed", "vega-embed.js"))"
        }
      });

      require(["d3", "vega", "vegalite", "vegaembed"],
              function(d3, vg, vgl, vge){
        // window.d3 = d3;

        var embedSpec = {
          mode: "vega-lite",
          renderer: "svg",
          actions: false,
          spec: $(JSON.json(v.vis))
        }

        vg.embed("#plot", embedSpec, function(error, result) {
        });
      });

    </script>

  </div>
  """

  println(fh)
  # writemime(io, m, fh)
  write(io, fh)
end


export writemime
