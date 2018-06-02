using Documenter, VegaLite

info("Building docs...")

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
        "Simple Charts" => "examples/examples_simplecharts.md"
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
