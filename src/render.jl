######################################################################
#
#     Default plotting using browser tab
#
######################################################################

asset(url...) = @compat readstring(joinpath(dirname(@__FILE__), "..", "deps", "node_modules", url...))

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
      <script>$(asset("vega", "build", "vega.min.js"))</script>
      <script>$(asset("vega-lite", "build", "vega-lite.min.js"))</script>
      <script>$(asset("vega-embed", "vega-embed.min.js"))</script>
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

      var opt = {
        mode: "vega-lite",
        renderer: "$(SVG ? "svg" : "canvas")",
        actions: $SAVE_BUTTONS
      }
      var spec = $(JSON.json(v.vis))
      vega.embed('#$divid', spec, opt);    
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

        # println("show :")
        # Base.show_backtrace(STDOUT, backtrace())
        # println()

        # Open the browser
        @static if VERSION < v"0.5.0-"
          @osx_only run(`open $tmppath`)
          @windows_only run(`cmd /c start $tmppath`)
          @linux_only   run(`xdg-open $tmppath`)
        else
          if is_apple()
            run(`open $tmppath`)
          elseif is_windows()
            run(`cmd /c start $tmppath`)
          elseif is_linux()
            run(`xdg-open $tmppath`)
          end
        end

    end

    return
end
