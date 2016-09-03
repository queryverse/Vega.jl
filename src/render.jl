######################################################################
#
#     Default plotting using browser tab
#
######################################################################

asset(url...) = @compat readstring(joinpath(dirname(@__FILE__), "..", "assets", "bower_components", url...))

#Vega Scaffold: https://github.com/vega/vega/wiki/Runtime
function writehtml(io::IO, v::VegaLiteVis; title="VegaLite plot")
  divid = "vg" * randstring(3)

  println(io,
  """
  <html>
    <head>
      <title>$title</title>
      <meta charset="UTF-8">
      <script>$(asset("d3","d3.min.js"))</script>
      <script>$(asset("vega", "vega.js"))</script>
      <script>$(asset("vega-lite", "vega-lite.js"))</script>
      <script>$(asset("vega-embed", "vega-embed.js"))</script>
    </head>
    <body>
      <div id="$divid"></div>
    </body>

    <style media="screen">
      .vega-actions a {
        margin-right: 10px;
        font-family: sans-serif;
        font-size: x-small;
        font-style: italic;
      }
    </style>

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

            println("show :")
            Base.show_backtrace(STDOUT, backtrace())
            println()

        # Open the browser
        @osx_only     run(`open $tmppath`)
        @windows_only run(`cmd /c start $tmppath`)
        @linux_only   run(`xdg-open $tmppath`)
    end

    return
end
