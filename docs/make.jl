using Documenter, VegaLite


makedocs(
  modules=[VegaLite],
  sitename = "VegaLite.jl",
  pages = [
    "Introduction" => "index.md",
    "Quick Tour" => "quick.md",
    "Global settings" => "global.md",
    "Outputs" => "output.md",
    "API reference" => "functions.md"]
)
