VERSION >= v"0.4" && __precompile__()

module VegaLite

using JSON, Compat, Requires
using PhantomJS

import Base: show

export renderer, actionlinks


###  Switch for plotting in SVGs or canvas  ###

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

###  Switch for showing or not the buttons under the plot  ###

global ACTIONSLINKS = true

"""
`actionlinks()::Bool`

show if plots will have (true) or not (false) the action links shown

`actionlinks(::Bool)`

indicate if actions links should be shown under the plot
"""
actionlinks() = ACTIONSLINKS
actionlinks(b::Bool) = (global ACTIONSLINKS ; ACTIONSLINKS = b)



include("schema_parsing.jl")
include("func_definition.jl")
include("func_documentation.jl")
include("render.jl")

### Integration with DataFrames
@require DataFrames begin
  function _data(df::DataFrames.DataFrame)
    adf = [ Dict(zip(names(df), vec(Array(df[i,:])))) for i in 1:size(df,1) ]
    VegaLite.VLSpec{:data}(Dict(:values => adf))
  end
end

### Integration with DataTables
@require DataTables begin
  function _data(dt::DataTables.DataTable)
    adt = [ Dict(zip(names(dt), vec(Array(dt[i,:])))) for i in 1:size(dt,1) ]
    VegaLite.VLSpec{:data}(Dict(:values => adt))
  end
end


### Integration with IJulia - Jupyter
# include("ijulia_integration.jl")

### Integration with Atom-Juno-Media
# include("atom_integration.jl")

end
