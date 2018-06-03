using Documenter, VegaLite

info("Building docs...")

Pkg.add("DataFrames")
Pkg.add("VegaDatasets")

makedocs(
  modules=[VegaLite],
  format=:html,
  sitename = "VegaLite.jl",
  pages = [
    "Home" => "index.md",
    "Getting Started" => Any[
        "Quick Tour" => "gettingstarted/quick.md"
    ],
    "Examples" => Any[
        "Simple Charts" => "examples/examples_simplecharts.md",
        "Bar Charts & Histograms" => "examples/examples_barchartshistograms.md",
        "Scatter & Strip Plots" => "examples/examples_scatter_strip_plots.md",
        "Line Charts" => "examples/examples_line_charts.md",
        "Area Charts & Streamgraphs" => "examples/examples_area_Charts_streamgraphs.md",
        "Table-based Plots" => "examples/examples_table_based_plots.md",
        "Faceting (Trellis Plot / Small Multiples)" => "examples/examples_faceting.md",
        "Repeat & Concatenation" => "examples/examples_repeat_concatenation.md"
    ],
    "User Guide" => Any[
        "Vega-lite specifications" => "userguide/vlspec.md"
    ],
    "Reference Manual" => [
        "Global settings" => "referencemanual/global.md",
        "Outputs" => "referencemanual/output.md",
        "API reference" => "referencemanual/functions.md"]
  ]
)

deploydocs(
    deps = nothing,
    make = nothing,
    target = "build",
    repo = "github.com/fredo-dedup/VegaLite.jl.git",
    julia = "0.6"
)
