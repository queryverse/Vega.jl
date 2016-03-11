###################################################################
#  Encoding related definitions & functions
###################################################################

encoding_mark_prop_spec = Dict(
  :aggregate   =>	AbstractString,
  :timeUnit    =>	AbstractString,
  :bin         =>	Union{Dict, Bool},
  :sort        =>	AbstractString,
  :scale       =>	Dict,
  :axis        =>	Union{Dict, Bool},
  :legend      =>	Union{Dict, Bool},
  :value       =>	Any,
  :field       =>	Symbol,
  :type        =>	AbstractString
)

for channel in [:x, :y, :color, :shape, :size, :text,
                :detail, :order, :path, :row, :column]
  fn = symbol("encoding_" * string(channel))
  path = (:encoding, channel)
  @eval ($fn)(;properties...) = _mkvis($path, encoding_mark_prop_spec, properties)
  @eval ($fn)(val::Symbol;properties...) = ($fn)(;vcat(properties, [(:field, val)])...)
  @eval ($fn)(val;properties...)         = ($fn)(;vcat(properties, [(:value, val)])...)

  for (ts, tn) in [(:quant, "quantitative"), (:temp,   "temporal"),
                   (:ord,   "ordinal")     , (:nominal, "nominal")]
    fn2 = symbol(string(fn) * "_" * string(ts))
    @eval ($fn2)(val;properties...)    = ($fn)(val;vcat(properties, [(:type, $tn)])...)
  end
end


"""
Sets encoding for a channel X with data type Y, with Y equal to `quant` (quantitative),
`temp` (temporal), `ord` (ordinal) or `nominal` (nominal).

```julia
encoding_*X*_*Y*(;properties...)
encoding_*X*_*Y*(val::Symbol;properties...) # binds to field [val]
encoding_*X*_*Y*(val;properties...) # sets to constant value [val]
```

Properties:

- `bin` (`Dict` or `Bool`) : Boolean flag for binning a quantitative field, or a bin property object for binning parameters. Default value: false
- `timeUnit` (`AbstractString`) : Time unit for a temporal field (e.g., year, yearmonth, month, hour). Default value: undefined (None)
- `aggregate` (`AbstractString`) : Aggregation function for the field (e.g., mean, sum, median, min, max, count). Default value: undefined (None)
- `sort` (`AbstractString`) : | Object	Sort order for a particular field. (Default value: "ascending")
  • For quantitative or temporal fields, this can be either "ascending" or , "descending"
  • For quantitative or temporal fields, this can be "ascending", "descending", "none", or a sort field definition object for sorting by an aggregate calculation of a specified sort field.
- `scale`(`Dict`)	: A property object for a scale of a mark property channel.
- `axis`(`Dict` or `Bool`) : Boolean flag for showing an axis (true by default), or a property object for an axis of a position channel (x or y) or a facet channel (row or column).
- `legend`(`Dict` or `Bool`) : Boolean flag for showing a legend (true by default), or a config object for a legend of a non-position mark property channel (color, size, or shape).

"""
encoding_x, encoding_x_quant, encoding_x_temp, encoding_x_ord, encoding_x_nominal,
encoding_y, encoding_y_quant, encoding_y_temp, encoding_y_ord, encoding_y_nominal,
encoding_color, encoding_color_quant, encoding_color_temp,
encoding_color_ord, encoding_color_nominal,
encoding_shape, encoding_shape_quant, encoding_shape_temp,
encoding_shape_ord, encoding_shape_nominal,
encoding_path, encoding_path_quant, encoding_path_temp,
encoding_path_ord, encoding_path_nominal,
encoding_size, encoding_size_quant, encoding_size_temp,
encoding_size_ord, encoding_size_nominal,
encoding_text, encoding_text_quant, encoding_text_temp,
encoding_text_ord, encoding_text_nominal,
encoding_detail, encoding_detail_quant, encoding_detail_temp,
encoding_detail_ord, encoding_detail_nominal,
encoding_order, encoding_order_quant, encoding_order_temp,
encoding_order_ord, encoding_order_nominal,
encoding_row, encoding_row_quant, encoding_row_temp,
encoding_row_ord, encoding_row_nominal,
encoding_column, encoding_column_quant, encoding_column_temp,
encoding_column_ord, encoding_column_nominal

# encoding_x(;properties...) = _mkvis((:encoding, :x), encoding_mark_prop_spec, properties)
#
# encoding_x(val::Symbol;properties...) = encoding_x(;vcat(properties, [(:field, val)])...)
# encoding_x(val;properties...)         = encoding_x(;vcat(properties, [(:value, val)])...)
#
# encoding_x_quant(val;properties...)   = encoding_x(val;vcat(properties, [(:type, "quantitative")])...)
# encoding_x_temp(val;properties...)    = encoding_x(val;vcat(properties, [(:type, "temporal")])...)
# encoding_x_ord(val;properties...)     = encoding_x(val;vcat(properties, [(:type, "ordinal")])...)
# encoding_x_nominal(val;properties...) = encoding_x(val;vcat(properties, [(:type, "nominal")])...)
#
# encoding_y(;properties...) = _mkvis((:encoding, :y), encoding_mark_prop_spec, properties)
#
# encoding_y(val::Symbol;properties...) = encoding_y(;vcat(properties, [(:field, val)])...)
# encoding_y(val;properties...)         = encoding_y(;vcat(properties, [(:value, val)])...)
#
# encoding_y_quant(val;properties...)   = encoding_y(val;vcat(properties, [(:type, "quantitative")])...)
# encoding_y_temp(val;properties...)    = encoding_y(val;vcat(properties, [(:type, "temporal")])...)
# encoding_y_ord(val;properties...)     = encoding_y(val;vcat(properties, [(:type, "ordinal")])...)
# encoding_y_nominal(val;properties...) = encoding_y(val;vcat(properties, [(:type, "nominal")])...)
#
# encoding_color(;properties...) = _mkvis((:encoding, :color), encoding_mark_prop_spec, properties)
#
# encoding_color(val::Symbol;properties...) = encoding_color(;vcat(properties, [(:field, val)])...)
# encoding_color(val;properties...)         = encoding_color(;vcat(properties, [(:value, val)])...)
#
# encoding_color_quant(val;properties...)   = encoding_color(val;vcat(properties, [(:type, "quantitative")])...)
# encoding_color_temp(val;properties...)    = encoding_color(val;vcat(properties, [(:type, "temporal")])...)
# encoding_color_ord(val;properties...)     = encoding_color(val;vcat(properties, [(:type, "ordinal")])...)
# encoding_color_nominal(val;properties...) = encoding_color(val;vcat(properties, [(:type, "nominal")])...)
#
# encoding_shape(;properties...) = _mkvis((:encoding, :shape), encoding_mark_prop_spec, properties)
#
# encoding_shape(val::Symbol;properties...) = encoding_shape(;vcat(properties, [(:field, val)])...)
# encoding_shape(val;properties...)         = encoding_shape(;vcat(properties, [(:value, val)])...)
#
# encoding_shape_quant(val;properties...)   = encoding_shape(val;vcat(properties, [(:type, "quantitative")])...)
# encoding_shape_temp(val;properties...)    = encoding_shape(val;vcat(properties, [(:type, "temporal")])...)
# encoding_shape_ord(val;properties...)     = encoding_shape(val;vcat(properties, [(:type, "ordinal")])...)
# encoding_shape_nominal(val;properties...) = encoding_shape(val;vcat(properties, [(:type, "nominal")])...)
#
# encoding_path(;properties...) = _mkvis((:encoding, :path), encoding_mark_prop_spec, properties)
#
# encoding_path(val::Symbol;properties...) = encoding_path(;vcat(properties, [(:field, val)])...)
# encoding_path(val;properties...)         = encoding_path(;vcat(properties, [(:value, val)])...)
#
# encoding_path_quant(val;properties...)   = encoding_path(val;vcat(properties, [(:type, "quantitative")])...)
# encoding_path_temp(val;properties...)    = encoding_path(val;vcat(properties, [(:type, "temporal")])...)
# encoding_path_ord(val;properties...)     = encoding_path(val;vcat(properties, [(:type, "ordinal")])...)
# encoding_path_nominal(val;properties...) = encoding_path(val;vcat(properties, [(:type, "nominal")])...)
