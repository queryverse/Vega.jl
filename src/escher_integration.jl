import Escher: Elem, Tile, render
import Base: convert

ESCHER_SVG = true
ESCHER_BUTTONS = true

export svg, buttons

svg() = ESCHER_SVG
svg(b::Bool) = (global ESCHER_SVG ; ESCHER_SVG = b)
buttons() = ESCHER_BUTTONS
buttons(b::Bool) = (global ESCHER_BUTTONS ; ESCHER_BUTTONS = b)


type VegaLiteTile <: Tile
  json::AbstractString
  svg::Bool
  actions::Bool
end

function VegaLiteTile(vis::AbstractString)
  VegaLiteTile(vis, ESCHER_SVG, ESCHER_BUTTONS)
end

convert(::Type{Tile}, v::VegaLiteVis) = VegaLiteTile(JSON.json(v.vis))

function render(plot::VegaLiteTile, state)
  attr = Dict(:json=>plot.json)
  plot.svg     && ( attr[:svg]     = "" )
  plot.actions && ( attr[:actions] = "" )

  Elem(:"vega-lite-plot", attributes = attr)
end
