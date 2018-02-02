using Documenter, VegaLite


makedocs(
  modules=[VegaLite],
  format=:html,
  sitename = "VegaLite.jl",
  pages = [
    "Introduction" => "index.md",
    "Quick Tour" => "quick.md",
    "Vega-lite specifications" => "vlspec.md",
    "Global settings" => "global.md",
    "Outputs" => "output.md",
    "API reference" => "functions.md"]
)

deploydocs(
    repo = "github.com/fredo-dedup/VegaLite.jl.git",
    julia = "0.6"
)
