VERSION >= v"0.4" && __precompile__()

module VegaLite

    using JSON
    # using ColorBrewer, Compat, KernelDensity, NoveltyColors

    # export tojs, print

    #Create base color library
    #Eventually, merge in NoveltyColors
    # colorpalettes = merge(ColorBrewer.colorSchemes, NoveltyColors.ColorDict)


    type VegaLiteVis
    end


    ### Integration with Escher
    Pkg.installed("Escher") != nothing && include("escher_integration.jl")

    ### Integration with IJulia
    # Pkg.installed("IJulia") != nothing && include("ijulia_integration.jl")

end
