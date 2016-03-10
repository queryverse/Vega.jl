import Escher: Elem, Tile, render
import Base: convert

type VegaLiteTile <: Tile
    json::AbstractString
end

# convert(::Type{Tile}, v::VegaLiteVis) = VegaLiteTile(JSON.json(tojs(v)))
convert(::Type{Tile}, v::VegaLiteVis) = VegaLiteTile(JSON.json(v.vis))

render(plot::VegaLiteTile, state) =
    Elem(:"vega-lite-plot", attributes = Dict(:json=>plot.json))
