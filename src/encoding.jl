

encoding_mark_prop_spec = Dict(
  :aggregate   =>	AbstractString,
  :timeUnit    =>	AbstractString,
  :bin         =>	AbstractString,
  :sort        =>	AbstractString,
  :scale       =>	Dict,
  :axis        =>	Dict,
  :value       =>	Union{AbstractString, Real},
  :field       =>	Symbol,
  :type        =>	AbstractString )


encoding_x(;properties...) = _mkvis((:encoding, :x), encoding_mark_prop_spec, properties)

encoding_x(val::Symbol;properties...) = encoding_x(;vcat(properties, [(:field, val)])...)
encoding_x(val;properties...)         = encoding_x(;vcat(properties, [(:value, val)])...)

encoding_x_quant(val;properties...)   = encoding_x(val;vcat(properties, [(:type, "quantitative")])...)
encoding_x_temp(val;properties...)    = encoding_x(val;vcat(properties, [(:type, "temporal")])...)
encoding_x_ord(val;properties...)     = encoding_x(val;vcat(properties, [(:type, "ordinal")])...)
encoding_x_nominal(val;properties...) = encoding_x(val;vcat(properties, [(:type, "nominal")])...)

encoding_y(;properties...) = _mkvis((:encoding, :y), encoding_mark_prop_spec, properties)

encoding_y(val::Symbol;properties...) = encoding_y(;vcat(properties, [(:field, val)])...)
encoding_y(val;properties...)         = encoding_y(;vcat(properties, [(:value, val)])...)

encoding_y_quant(val;properties...)   = encoding_y(val;vcat(properties, [(:type, "quantitative")])...)
encoding_y_temp(val;properties...)    = encoding_y(val;vcat(properties, [(:type, "temporal")])...)
encoding_y_ord(val;properties...)     = encoding_y(val;vcat(properties, [(:type, "ordinal")])...)
encoding_y_nominal(val;properties...) = encoding_y(val;vcat(properties, [(:type, "nominal")])...)

encoding_color(;properties...) = _mkvis((:encoding, :color), encoding_mark_prop_spec, properties)

encoding_color(val::Symbol;properties...) = encoding_color(;vcat(properties, [(:field, val)])...)
encoding_color(val;properties...)         = encoding_color(;vcat(properties, [(:value, val)])...)

encoding_color_quant(val;properties...)   = encoding_color(val;vcat(properties, [(:type, "quantitative")])...)
encoding_color_temp(val;properties...)    = encoding_color(val;vcat(properties, [(:type, "temporal")])...)
encoding_color_ord(val;properties...)     = encoding_color(val;vcat(properties, [(:type, "ordinal")])...)
encoding_color_nominal(val;properties...) = encoding_color(val;vcat(properties, [(:type, "nominal")])...)

encoding_shape(;properties...) = _mkvis((:encoding, :shape), encoding_mark_prop_spec, properties)

encoding_shape(val::Symbol;properties...) = encoding_shape(;vcat(properties, [(:field, val)])...)
encoding_shape(val;properties...)         = encoding_shape(;vcat(properties, [(:value, val)])...)

encoding_shape_quant(val;properties...)   = encoding_shape(val;vcat(properties, [(:type, "quantitative")])...)
encoding_shape_temp(val;properties...)    = encoding_shape(val;vcat(properties, [(:type, "temporal")])...)
encoding_shape_ord(val;properties...)     = encoding_shape(val;vcat(properties, [(:type, "ordinal")])...)
encoding_shape_nominal(val;properties...) = encoding_shape(val;vcat(properties, [(:type, "nominal")])...)

encoding_path(;properties...) = _mkvis((:encoding, :path), encoding_mark_prop_spec, properties)

encoding_path(val::Symbol;properties...) = encoding_path(;vcat(properties, [(:field, val)])...)
encoding_path(val;properties...)         = encoding_path(;vcat(properties, [(:value, val)])...)

encoding_path_quant(val;properties...)   = encoding_path(val;vcat(properties, [(:type, "quantitative")])...)
encoding_path_temp(val;properties...)    = encoding_path(val;vcat(properties, [(:type, "temporal")])...)
encoding_path_ord(val;properties...)     = encoding_path(val;vcat(properties, [(:type, "ordinal")])...)
encoding_path_nominal(val;properties...) = encoding_path(val;vcat(properties, [(:type, "nominal")])...)
