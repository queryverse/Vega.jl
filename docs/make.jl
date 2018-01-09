using Documenter, VegaLite


makedocs(
  modules=[VegaLite],
  format=:html,
  sitename = "VegaLite.jl",
  pages = [
    "Introduction" => "index.md",
    "Quick Tour" => "quick.md",
    "Global settings" => "global.md",
    "Outputs" => "output.md",
    "API reference" => "functions.md"]
)

deploydocs(
    deps=nothing,
    make=nothing,
    target="build",
    repo = "github.com/fredo-dedup/VegaLite.jl.git",
    julia = "0.6"
)
