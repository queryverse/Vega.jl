######################################################################
#
#     Escher Integration
#
#     - Defines a new Tile type : VegaLiteTile and its render function
#
######################################################################

@require Escher begin

  import Escher: Elem, Tile, render
  import Base: convert

  type VegaLiteTile <: Tile
    json::AbstractString
    svg::Bool
    actions::Bool
  end

  function VegaLiteTile(vis::AbstractString)
    VegaLiteTile(vis, SVG, SAVE_BUTTONS)
  end

  convert(::Type{Tile}, v::VegaLiteVis) = VegaLiteTile(JSON.json(v.vis))

  function render(plot::VegaLiteTile, state)
    attr = Dict(:json=>plot.json)
    plot.svg     && ( attr[:svg]     = "" )
    plot.actions && ( attr[:actions] = "" )

    Elem(:"vega-lite-plot", attributes = attr)
  end

end
