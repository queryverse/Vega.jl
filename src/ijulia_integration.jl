######################################################################
#
#     IJulia Integration
#
#     - consist in defining a writemime(::IO, m::MIME"text/html", v::VegaLiteVis)
#       including scripts that load the required libraries (D3, vega, vega-lite)
#     - Will it work with other html backends ?  probably not.
#
######################################################################

import Base.writemime

# FIXME : Apparently, loading local js files is not allowed by the browser
#   => libraries are loaded externally in the `require.config`

# function jslibpath(url...)
#   libpath = Pkg.dir("VegaLite", "assets", "bower_components", url...)
#   replace(libpath, "\\", "/")  # for windows...
# end
# // d3: "$(jslibpath("d3","d3.min.js"))",
# // vega: "$(jslibpath("vega", "vega.js"))",
# // vegalite: "$(jslibpath("vega-lite", "vega-lite.js"))",
# // vegaembed: "$(jslibpath("vega-embed", "vega-embed.js"))"


function writemime(io::IO, m::MIME"text/html", v::VegaLiteVis)
  divid = "vl" * randstring(10) # generated id for this plot

  fh = """
  <div>
    <div id="$divid"></div>

    <meta charset="utf-8">

    <script type="text/javascript">
      require.config({
        paths: {
          d3:        "https://d3js.org/d3.v3.min",
          vega:      "https://vega.github.io/vega/vega",
          vegalite:  "https://vega.github.io/vega-lite/vega-lite",
          vegaembed: "https://vega.github.io/vega-editor/vendor/vega-embed"
        }
      });

      require(["d3"], function(d3){
        window.d3 = d3;

        require(["vega"], function(vg) {
          window.vg = vg

          require(["vegalite"], function(vgl) {

            var embedSpec = {
              mode: "vega-lite",
              renderer: "$(SVG ? "svg" : "canvas")",
              actions: $SAVE_BUTTONS,
              spec: $(JSON.json(v.vis))
            }

            var vgSpec = vgl.compile(embedSpec.spec).spec;
            vg.parse.spec(vgSpec, function(chart) { chart({el:\"#$divid\"}).update(); });

          });
        });
      });

    </script>

  </div>
  """
  # FIXME : understand why vega-embed can't be loaded
  #   SVG and SAVE_BUTTONS flags are ignored
  # vg.embed("#$divid", embedSpec, function(error, result) {

  write(io, fh)
end


export writemime
