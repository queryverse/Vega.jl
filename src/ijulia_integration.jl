######################################################################
#
#     IJulia Integration
#
#     - Consists in defining writemime(::IO, m::MIME"text/html", v::VegaLiteVis)
#        only when IJulia is loaded.
#     - Signals to Jupyter the required libs (D3, vega, vega-lite)
#
######################################################################

@require IJulia begin  # define only if/when IJulia is loaded

  @compat import Base.show

  # FIXME : Apparently, loading local js files is not allowed by the browser
  #   => libraries are loaded externally in the `require.config`

  # function jslibpath(url...)
  #   libpath = joinpath(dirname(@__FILE__), "..", "assets", "bower_components", url...)
  #   replace(libpath, "\\", "/")  # for windows...
  # end
  # // d3: "$(jslibpath("d3","d3.min.js"))",
  # // vega: "$(jslibpath("vega", "vega.js"))",
  # // vegalite: "$(jslibpath("vega-lite", "vega-lite.js"))",
  # // vegaembed: "$(jslibpath("vega-embed", "vega-embed.js"))"

  @compat function show(io::IO, m::MIME"text/html", v::VegaLiteVis)
    divid = "vl" * randstring(10) # generated id for this plot

    fh = """
    <div>
      <div id="$divid"></div>

      <style media="screen">
        .vega-actions a {
          margin-right: 10px;
          font-family: sans-serif;
          font-size: x-small;
          font-style: italic;
        }
      </style>

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

              require(["vegaembed"], function(vge) {

                var embedSpec = {
                  mode: "vega-lite",
                  renderer: "$(SVG ? "svg" : "canvas")",
                  actions: $SAVE_BUTTONS,
                  spec: $(JSON.json(v.vis))
                }

            //    vg.embed("#$divid", embedSpec, function(error, result) {
            //    });

                var vgSpec = vgl.compile(embedSpec.spec).spec;
                vg.parse.spec(vgSpec, function(chart) { chart({el:\"#$divid\"}).update(); });

              });
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

end
