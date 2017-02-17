######################################################################
#
#     Atom Integration
#
#     - Inhibits display of VegaLite plots in Atom to avoid having plots
#          sent twice to the browser
#
######################################################################

@require Atom begin  # define only if/when Atom is loaded

  function writemime(io::IO, m::MIME"text/html", v::VegaLiteVis)
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
  import Atom, Media

  Media.media(VegaLiteVis, Media.Plot)

  function Media.render(e::Atom.Editor, plt::VegaLiteVis)
    Media.render(e, nothing)
  end

end
