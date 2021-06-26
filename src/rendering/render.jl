######################################################################
#
#     Rendering
#
######################################################################
using JSON

asset(url...) = normpath(joinpath(vegalite_app_path, "minified", url...))

package_json = JSON.parsefile(joinpath(vegalite_app_path, "package.json"))
version(package) = package_json["dependencies"][package]

# Vega Scaffold: https://github.com/vega/vega/wiki/Runtime

function writehtml_full(io::IO, spec::VGSpec; title="Vega plot")
    divid = "vg" * randstring(3)

    println(io,
  """
  <html>
    <head>
      <title>$title</title>
      <meta charset="UTF-8">
      <script>$(read(asset("vega.min.js"), String))</script>
      <script>$(read(asset("vega-embed.min.js"), String))</script>
    </head>
    <body>
      <div id="$divid" style="width:100%;height:100%;"></div>
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
        mode: "vega",
        renderer: "$RENDERER",
        actions: $ACTIONSLINKS
      }

      var spec = """)

    our_json_print(io, spec)
    println(io)

    println(io, """
      vegaEmbed('#$divid', spec, opt);

    </script>

  </html>
  """)
end

function writehtml_full(spec::VGSpec; title="Vega plot")
    tmppath = string(tempname(), ".vega.html")

    open(tmppath, "w") do io
        writehtml_full(io, spec, title=title)
    end

    tmppath
end

"""
Creates a HTML script + div block for showing the plot (typically for Pluto).
VegaLite js files are loaded from the web using script tags.
"""
function writehtml_partial_script(io::IO, spec::VGSpec; title="VegaLite plot")
    divid = "vg" * randstring(3)
    print(io, """
    <style media="screen">
      .vega-actions a {
        margin-right: 10px;
        font-family: sans-serif;
        font-size: x-small;
        font-style: italic;
      }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/vega@$(version("vega"))/build/vega.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vega-embed@$(version("vega-embed"))/build/vega-embed.min.js"></script>

    <div id="$divid"></div>

    <script>
      var spec = """)
    our_json_print(io, spec)
    print(io,"""
      ;
      var opt = {
        mode: "vega-lite",
        renderer: "$(Vega.RENDERER)",
        actions: $(Vega.ACTIONSLINKS)
      };
      vegaEmbed("#$divid", spec, opt);
    </script>
  """)
end


"""
opens a browser tab with the given html file
"""
function launch_browser(tmppath::String)
    if Sys.isapple()
        run(`open $tmppath`)
    elseif Sys.iswindows()
    run(`cmd /c start $tmppath`)
  elseif Sys.islinux()
    run(`xdg-open $tmppath`)
    end
end

function Base.display(d::REPL.REPLDisplay, plt::VGSpec)
    tmppath = writehtml_full(plt)
    launch_browser(tmppath) # Open the browser
end
