VERSION >= v"0.4" && __precompile__()

module VegaLite

using JSON, Compat, Requires

import Base: +, *, scale, show

export VegaLiteVis, scale, axis, legend

export svg, buttons

export data_values

export config_grid, config_facet_axis, config_facet_cell,
    config_facet_scale

export config, config_cell, config_mark, config_scale,
    config_axis, config_legend

export mark_bar, mark_circle, mark_square, mark_tick,
    mark_line, mark_area, mark_point, mark_text

export encoding_x_quant, encoding_x_temp, encoding_x_ord, encoding_x_nominal,
    encoding_y_quant, encoding_y_temp, encoding_y_ord, encoding_y_nominal,
    encoding_color_quant, encoding_color_temp, encoding_color_ord, encoding_color_nominal,
    encoding_shape_quant, encoding_shape_temp, encoding_shape_ord, encoding_shape_nominal,
    encoding_path_quant, encoding_path_temp, encoding_path_ord, encoding_path_nominal,
    encoding_size_quant, encoding_size_temp, encoding_size_ord, encoding_size_nominal,
    encoding_text_quant, encoding_text_temp, encoding_text_ord, encoding_text_nominal,
    encoding_detail_quant, encoding_detail_temp, encoding_detail_ord, encoding_detail_nominal,
    encoding_order_quant, encoding_order_temp, encoding_order_ord, encoding_order_nominal,
    encoding_row_quant, encoding_row_temp, encoding_row_ord, encoding_row_nominal,
    encoding_column_quant, encoding_column_temp, encoding_column_ord, encoding_column_nominal


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
