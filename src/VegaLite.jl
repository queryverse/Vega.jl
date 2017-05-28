VERSION >= v"0.4" && __precompile__()

module VegaLite

using JSON, Compat, Requires
using PhantomJS

import Base: show

export svg, buttons




#  Switch for plotting in SVGs or canvas
SVG = true
svg() = SVG
svg(b::Bool) = (global SVG ; SVG = b)




#  Switch for showing or not the "save as PNG buttons"
SAVE_BUTTONS = true
buttons() = SAVE_BUTTONS
buttons(b::Bool) = (global SAVE_BUTTONS ; SAVE_BUTTONS = b)



include("utils.jl")
include("render.jl")
include("axis.jl")
include("scale.jl")
include("legend.jl")
include("config.jl")
include("data_values.jl")
include("mark.jl")
include("encoding.jl")

### Integration with Escher (Escher does not seem to work in 0.5)
# include("escher_integration.jl")

### Integration with DataFrames
include("dataframes_integration.jl")

### Integration with IJulia - Jupyter
include("ijulia_integration.jl")

### Integration with Atom-Juno-Media
include("atom_integration.jl")

end
