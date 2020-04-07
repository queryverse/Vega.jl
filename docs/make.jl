using Documenter, Vega, UUIDs

function Base.show(io::IO, m::MIME"text/html", v::Vega.VGSpec)
    divid = string("vg", replace(string(uuid4()), "-"=>""))
    print(io, "<div id='$divid' style=\"width:100%;height:100%;\"></div>")
    print(io, "<script type='text/javascript'>requirejs.config({paths:{'vg-embed': 'https://cdn.jsdelivr.net/npm/vega-embed@6?noext','vega-lib': 'https://cdn.jsdelivr.net/npm/vega-lib?noext','vega-lite': 'https://cdn.jsdelivr.net/npm/vega-lite@4?noext','vega': 'https://cdn.jsdelivr.net/npm/vega@5?noext'}}); require(['vg-embed'],function(vegaEmbed){vegaEmbed('#$divid',")
    Vega.our_json_print(io, v)
    print(io, ",{mode:'vega'}).catch(console.warn);})</script>")
end

makedocs(
  modules=[Vega],
  sitename = "Vega.jl",
  pages = [
    "Home" => "index.md",
    "Getting Started" => Any[
        "Installation" => "gettingstarted/installation.md"
    ],
    "User Guide" => Any[
        "Using Vega" => "userguide/vega.md"
    ],
    "Examples" => Any[
        
        "Line & Area Charts" => "examples/examples_vega_line_area_charts.md",
        "Circular Charts" => "examples/examples_vega_circular_charts.md",
        "Scatter Plots" => "examples/examples_vega_scatter_plots.md",
        "Tree Diagrams" => "examples/examples_vega_tree_diagrams.md",
        "Network Diagrams" => "examples/examples_vega_network_diagrams.md",
        "Single Data Source" => "examples/examples_vega_single_data_source.md",
        "Multiple Data Source" => "examples/examples_vega_multi_data_source.md"
    ],
    "Reference Manual" => [
        "Global settings" => "referencemanual/global.md",
        "Outputs" => "referencemanual/output.md"]
  ]
)

deploydocs(
    repo = "github.com/queryverse/Vega.jl.git",
)
