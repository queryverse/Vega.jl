
asset(url...) = @compat readstring(Pkg.dir("VegaLite", "assets", "bower_components", url...))

#Vega Scaffold: https://github.com/vega/vega/wiki/Runtime
function writehtml(io::IO, v::VegaLiteVis; title="VegaLite plot")
  divid = "vg" * randstring(3)

  println(io,
  """
  <html>
    <head>
      <title>$title</title>
      <script>$(asset("d3","d3.min.js"))</script>
      <script>$(asset("vega", "vega.js"))</script>
      <script>$(asset("vega-lite", "vega-lite.js"))</script>
      <script>$(asset("vega-embed", "vega-embed.js"))</script>

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
