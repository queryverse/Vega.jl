module Vega

using JSON, NodeJS # 6s
import IteratorInterfaceExtensions # 1s
import TableTraits # 0
using FileIO # 17s !!!
using DataValues  # 1s
import MacroTools
using URIParser
using FilePaths
using REPL, Dates
using Random
import JSONSchema
using Setfield: Setfield, PropertyLens, @lens, @set
# import Cairo, Rsvg
using Pkg.Artifacts
using DataStructures
import TableTraitsUtils

export renderer, actionlinks
export @vg_str, @vgplot, vgplot, @vgfrag, vgfrag
export load, save
export deletedata, deletedata!

const vegaliate_app_path = artifact"vegalite_app"
const vegaliate_app_includes_canvas = ispath(joinpath(vegaliate_app_path, "node_modules", "canvas"))

########################  settings functions  ############################

# Switch for plotting in SVGs or canvas

global RENDERER = :svg

"""
`renderer()`

show current rendering mode (svg or canvas)

`renderer(::Symbol)`

set rendering mode (svg or canvas)
"""
renderer() = RENDERER
function renderer(m::Symbol)
    global RENDERER
    m in [:svg, :canvas] || error("rendering mode should be either :svg or :canvas")
    RENDERER = m
end


# Switch for showing or not the buttons under the plot

global ACTIONSLINKS = true

"""
`actionlinks()::Bool`

show if plots will have (true) or not (false) the action links displayed

`actionlinks(::Bool)`

indicate if actions links should be dislpayed under the plot
"""
actionlinks() = ACTIONSLINKS
actionlinks(b::Bool) = (global ACTIONSLINKS ; ACTIONSLINKS = b)


########################  includes  #####################################
include("spec_utils.jl")
include("vgspec.jl")

include("dsl_vlplot_function/dsl_vlplot_function.jl")
include("dsl_vlplot_macro/dsl_vlplot_macro.jl")
include("dsl_str_macro/dsl_str_macro.jl")

include("rendering/to_julia.jl")
include("rendering/render.jl")
include("rendering/io.jl")
include("rendering/show.jl")
include("rendering/fileio.jl")

end
