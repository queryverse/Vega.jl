# VERSION >= v"0.4" && __precompile__()

module VegaLite

    using JSON
    # using ColorBrewer, Compat, KernelDensity, NoveltyColors

    import Base: +,*

    export VegaLiteVis

    export data_values

    export config, config_cell, config_grid, config_facet_axis,
           config_facet_cell, config_facet_scale, config_mark,
           config_scale, config_axis

    export mark_bar, mark_circle, mark_square, mark_tick,
           mark_line, mark_area, mark_point, mark_text

    export encoding_x, encoding_x_quant, encoding_x_temp,
           encoding_x_ord, encoding_x_nominal

    export encoding_y, encoding_y_quant, encoding_y_temp,
           encoding_y_ord, encoding_y_nominal

    export encoding_color, encoding_color_quant, encoding_color_temp,
           encoding_color_ord, encoding_color_nominal

    export encoding_shape, encoding_shape_quant, encoding_shape_temp,
           encoding_shape_ord, encoding_shape_nominal

    export encoding_path, encoding_path_quant, encoding_path_temp,
           encoding_path_ord, encoding_path_nominal



    #Create base color library
    #Eventually, merge in NoveltyColors
    # colorpalettes = merge(ColorBrewer.colorSchemes, NoveltyColors.ColorDict)


    type VegaLiteVis
        vis::Dict{}
    end


    +(a::VegaLiteVis, b::VegaLiteVis) = VegaLiteVis(softmerge(a.vis, b.vis))
    *(a::VegaLiteVis, b::VegaLiteVis) = VegaLiteVis(merge(a.vis, b.vis))

    function softmerge(a::Dict, b::Dict)
        ck = intersect(keys(a), keys(b))
        nd = merge(a, b)
        for k in ck
            nd[k] = softmerge(a[k], b[k])
        end
        nd
    end
    softmerge(a::Dict, b::Any) = a
    softmerge(a::Any, b::Dict) = b
    softmerge(a, b) = b


    function _mkvis(pos::Tuple, signature, properties)
      d = Dict()
      for (p,v) in properties
        haskey(signature, p) || error("unknown property $p")
        isa(v, signature[p]) || error("property $p : expected $(signature[p]), got $(typeof(v))")
        d[p] = v
      end

      for k in reverse(pos)
        d = Dict(k => d)
      end
      VegaLiteVis(d)
    end

    include("config.jl")
    include("data.jl")
    include("mark.jl")
    include("encoding.jl")

    ### Integration with Escher
    Pkg.installed("Escher") != nothing && include("escher_integration.jl")


end
