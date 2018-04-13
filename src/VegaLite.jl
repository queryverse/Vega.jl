__precompile__()
module VegaLite

using JSON, Compat, Requires, NodeJS, Cairo, Rsvg, NamedTuples
import IteratorInterfaceExtensions, TableTraits, FileIO, DataValues

import Base: |>

# This import can eventually be removed, it currently just makes sure
# that the iterable tables integration for DataFrames and friends
# is loaded
import IterableTables

export renderer, actionlinks
export png, svg, jgp, pdf, savefig, loadspec, savespec, @vl_str

export mark, enc

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

include("vlspec.jl")

include("schema_parsing.jl")
include("func_definition.jl")
include("func_documentation.jl")
include("spec_validation.jl")

include("dsl.jl")
# include("utils.jl")

include("render.jl")
include("juno_integration.jl")
include("io.jl")
include("show.jl")
include("macro.jl")
include("fileio.jl")


function __init__()

    global mark, enc

    ### encoding family : enc.x.quantitative, ...

    function mkfunc1(dim, typ)
        if typ == :value
            function (val, args...; kwargs...)
                pars = todicttree(args...; value=val, kwargs...)
                VLSpec{:vlencoding}(;[(dim, pars);]...)
            end
        else
            function (field, args...; kwargs...)
                pars = todicttree(args...; field=field, typ=typ, kwargs...)
                VLSpec{:vlencoding}(;[(dim, pars);]...)
            end
        end
    end

    channels = Symbol.(collect(keys(refs["EncodingWithFacet"].props)))
    chantyps = Symbol.(collect(union(refs["BasicType"].enum, refs["GeoType"].enum)))
    push!(chantyps, :value)

    typnt = NamedTuples.make_tuple( chantyps )

    encs = []
    for ch in channels
        push!(encs, typnt( [ mkfunc1(ch, tp) for tp in chantyps ]... ) )
    end
    enc = NamedTuples.make_tuple( channels )( encs... )

    # export enc

    #####  mark family : mark.line(), ...

    function mkfunc2(typ)
        function (args...; kwargs...)
            VLSpec{:vlmark}(args...; typ=typ, kwargs...)
        end
    end


    # this fails at precompilation
    marktyps = Symbol.(collect(refs["Mark"].enum))
    marknt = NamedTuples.make_tuple( marktyps )

    # => switch to explicit creation
    # marktyps = Symbol[:tick, :bar, :square, :point, :line, :rect, :area, :circle, :rule, :text, :geoshape]
    # marknt = @NT(tick, bar, square, point, line, rect, area, circle, rule, text, geoshape)
    #
    mark = marknt([ mkfunc2(typ) for typ in marktyps ]...)

    # export mark


end




end
