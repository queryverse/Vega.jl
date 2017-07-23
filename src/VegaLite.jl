VERSION >= v"0.4" && __precompile__()

module VegaLite

using JSON, Compat, Requires, NodeJS, Cairo, Rsvg
# using PhantomJS

# import Base: show
import Base: display, REPL.REPLDisplay
import Base: |>

export renderer, actionlinks, junoplotpane, png, svg, jgp, pdf, savefig


########################  settings functions  ###############################

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


# Switch for showing plots in a browser or in the plotpane when in Juno

global JUNOPLOTPANE = false

"""
`junoplotpane()::Bool`

when using Juno, show if plots will be rendered in plotpane or not

`junoplotpane(::Bool)`

set if plots should be rendered in Juno's plotpane or not
"""
junoplotpane() = JUNOPLOTPANE
junoplotpane(b::Bool) = (global JUNOPLOTPANE ; JUNOPLOTPANE = b)



########################  includes  #####################################

include("schema_parsing.jl")
include("func_definition.jl")
include("func_documentation.jl")
include("spec_validation.jl")
include("utils.jl")
include("render.jl")
include("juno_integration.jl")
include("io.jl")
include("show.jl")


########################  conditional definitions  #######################

### Integration with DataFrames
@require DataFrames begin
  function vldata(d::DataFrames.DataFrame)
    recs = [ Dict(r) for r in DataFrames.eachrow(d) ]
    VegaLite.VLSpec{:data}(Dict("values" => recs))
  end

  |>(a::DataFrames.DataFrame, b::VLSpec) = vldata(a) |> b
end

### Integration with DataTables
@require DataTables begin
  function vldata(d::DataTables.DataTable)
    recs = [ Dict(r) for r in DataTables.eachrow(d) ]
    VegaLite.VLSpec{:data}(Dict("values" => recs))
  end

  |>(a::DataTables.DataTable, b::VLSpec) = vldata(a) |> b
end

### Integration with Juno
include("juno_integration.jl")

end
