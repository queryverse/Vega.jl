########### top-level configuration ##############

config_spec = Dict(
  :viewport     => Vector,
  :background   => AbstractString,
  :timeFormat   => AbstractString,
  :numberFormat => AbstractString
)


"""
Sets top-level properties
config(;properties...)

- `viewport` (`Vector{Real}`) : The width and height of the on-screen viewport, in pixels. If necessary, clipping and scrolling will be applied. Default value: (none)
- `background` (`AbstractString`) : CSS color property to use as background of visualization. Default value: (none)
- `timeFormat` (`AbstractString`) : The default time format pattern for text and labels of axes and legends (in the form of D3 time format pattern). Default value: '%Y-%m-%d'.
- `numberFormat` (`AbstractString`) : The default number format pattern for text and labels of axes and legends (in the form of D3 number format pattern). Default value: 's'.
"""
config(;properties...) = _mkvis((:config, ), config_spec, properties)



########### cell-level configuration ##############

config_cell_spec = Dict(
  :width            =>	Real,
  :height           =>	Real,
  :fill             =>	AbstractString,
  :fillOpacity      =>	Real,
  :stroke           =>	AbstractString,
  :strokeOpacity    =>	Real,
  :strokeWidth      =>	Real,
  :strokeDash       =>	Vector,
  :strokeDashOffset =>	Vector
)


"""
Sets cell properties
config_cell(;properties...)

- `width` (`Real`) :	The width of the single plot or each plot in a trellis plot when the visualization has continuous x-scale. (If the plot has ordinal x-scale, the width is determined by the x-scale’s bandSize and the cardinality of the x-scale. If the plot does not have a field on x, the width is derived from scale config’s bandSize for all marks except text and from scale config’s textBandWidth for text mark.) Default value: 200
- `height` (`Real`) :	The height of the single plot or each plot in a trellis plot when the visualization has continuous y-scale. (If the visualization has ordinal y-scale, the height is determined by the bandSize and the cardinality of the y-scale. If the plot does not have a field on y, the height is scale config’s bandSize.) Default value: 200
- `fill` (`AbstractString`) :	The fill color. Default value: (none)
- `fillOpacity` (`Real`) :	The fill opacity (value between [0,1]). Default value: (none)
- `stroke` (`AbstractString`) :	The stroke color. Default value: (none)
- `strokeOpacity` (`Real`) :	The stroke opacity (value between [0,1]). Default value: (none)
- `strokeWidth` (`Number`) :	The stroke width, in pixels. Default value: (none)
- `strokeDash` (`Vector{Real}`) : An array of alternating stroke, space lengths for creating dashed or dotted lines. Default value: (none)
- `strokeDashOffset` (`Vector{Real}`) : The offset (in pixels) into which to begin drawing with the stroke dash array. Default value: (none)

"""
config_cell(;properties...) = _mkvis((:config, :cell), config_cell_spec, properties)

########### mark-level configuration ##############

config_mark_spec = Dict(
  :filled           => Bool,
  :color            => AbstractString,
  :fill             => AbstractString,
  :stroke           => AbstractString,
  :opacity          => Real,
  :fillOpacity      => Real,
  :strokeOpacity    => Real,
  :strokeWidth      => Real,
  :strokeDash       => Vector,
  :strokeDashOffset => Vector,
  :stacked          => AbstractString,
  :interpolate      => AbstractString,
  :tension          => Real,
  :orient           => AbstractString,
  :barSize          => Real,
  :shape            => AbstractString,
  :size             => Real,
  :tickSize         => Real,
  :tickThickness    => Real,
  :angle            => Real,
  :align            => AbstractString,
  :baseline         => AbstractString,
  :dx               => Real,
  :dy               => Real,
  :radius           => Real,
  :theta            => Real,
  :font             => AbstractString,
  :fontSize         => Real,
  :fontStyle        => AbstractString,
  :fontWeight       => AbstractString,
  :text             => AbstractString,
  :format           => AbstractString,
  :shortTimeLabels  => Bool
)


"""
Sets mark properties

config_mark(;properties...)

- `filled` (`Bool`) :	Whether the shape's color should be used as fill color instead of stroke color. See mark for a usage example. Default value: true for all marks except point and false for point. Applicable for: bar, point, circle, square, and area marks.
- `color` (`AbstractString`) :	The color of the mark – either fill or stroke color based on the filled mark config. Default value: ■ blue (""#4682b4")
- `fill` (`AbstractString`) :	The fill color. This config will be overridden by color channel’s specified or mapped values if filled is true. Default value: (None)
- `stroke` (`AbstractString`) :	The stroke color. This config will be overridden by color channel’s specified or mapped values if filled is false. Default value: (None)

Opacity

- `opacity` (`Real`) : The overall opacity (value between [0,1]). Default value: 0.7 for non-aggregate plots with point, tick, circle, or square marks and 1 otherwise.
- `fillOpacity` (`Real`) :	The fill opacity (value between [0,1]). Default value: 1
- `strokeOpacity` (`Real`) :	The stroke opacity (value between [0,1]). Default value: 1

Stroke Style

- `strokeWidth` (`Real`) : The stroke width, in pixels.
- `strokeDash` (`Vector{Real}`) : An array of alternating stroke, space lengths for creating dashed or dotted lines.
- `strokeDashOffset` (`Vector{Real}`) : The offset (in pixels) into which to begin drawing with the stroke dash array.

Stacking (for Bar and Area)

- `stacked` (`AbstractString`) :	Stacking modes for bar and area marks.
  • zero - stacking with baseline offset at zero value of the scale (for creating typical stacked bar and area chart).
  • normalize - stacking with normalized domain (for creating normalized stacked bar and area chart).
  • center - stacking with center baseline (for streamgraph).
  • none - No-stacking. This will produces layered bar and area chart. Default value: zero if applicable.

Interpolation (for Line and Area Marks)

- `interpolate` (`AbstractString`) :	The line interpolation method to use. One of "linear", "step-before", "step-after", "basis", "basis-open", "basis-closed", "bundle", "cardinal", "cardinal-open", "cardinal-closed", "monotone". For more information about each interpolation method, please see D3’s line interpolation.
- `tension` (`Real`) :	Depending on the interpolation type, sets the tension parameter. (See D3’s line interpolation.)

Orientation (for Bar, Tick, Line, and Area Marks)

- `orient` (`AbstractString`) :	The orientation of a non-stacked bar, area, and line charts. The value is either "horizontal", or "vertical" (default). For bar and tick, this determines whether the size of the bar and tick should be applied to x or y dimension. For area, this property determines the orient property of the Vega output. For line, this property determines the path order of the points in the line if path channel is not specified. For stacked charts, this is always determined by the orientation of the stack; therefore explicitly specified value will be ignored.

Bar Config

- `barSize` (`Real`) :	The size of the bars (width for vertical bar charts and height for horizontal bar chart). Default value: bandSize-1 if the bar’s x or y axis is an ordinal scale. (This provides 1 pixel offset between bars.) and 2 for if both x and y scales have linear scales.

Point Config

- `shape` (`AbstractString`) : The symbol shape to use. One of "circle", "square", "cross", "diamond", "triangle-up", or "triangle-down". Default value: "circle"

Point Size Config (for Point, Circle, and Square Marks)

- `size` (`Real`) :	The pixel area each the point. For example: in the case of circles, the radius is determined in part by the square root of the size value. Default value: 30

Tick Config

- `tickSize` (`Real`) : The size of the ticks (height of the ticks for horizontal dot plots and strip plots and width of the ticks for vertical dot plots and strip plots). Default value: 2/3*bandSize (This will provide offset between band equals to the width of the tick.)
- `tickThickness` (`Real`) : Thickness of the tick mark. Default value: 1

Text Config

Text Position

- `angle` (`Real`) : The rotation angle of the text, in degrees.
- `align` (`AbstractString`) :	The horizontal alignment of the text. One of left, right, center.
- `baseline` (`AbstractString`) :	The vertical alignment of the text. One of top, middle, bottom.
- `dx` (`Real`) :	The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the angle property.
- `dy` (`Real`) :	The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the angle property.
- `radius` (`Real`) :	Polar coordinate radial offset, in pixels, of the text label from the origin determined by the x and y properties.
- `theta` (`Real`) :	Polar coordinate angle, in radians, of the text label from the origin determined by the x and y properties. Values for theta follow the same convention of arc mark startAngle and endAngle properties: angles are measured in radians, with 0 indicating “north”.

Font Style

- `font` (`AbstractString`) :	The typeface to set the text in (e.g., Helvetica Neue).
- `fontSize` (`Real`) : : The font size, in pixels. The default value is 10.
- `fontStyle` (`AbstractString`) :	The font style (e.g., italic).
- `fontWeight` (`AbstractString`) :	The font weight (e.g., bold).

Text Value and Format

- `text` (`AbstractString`) :	Placeholder text if the text channel is not specified ("Abc" by default).
- `format` (`AbstractString`) :	The formatting pattern for text value. If not defined, this will be determined automatically
- `shortTimeLabels` (`Bool`) : Whether month names and weekday names should be abbreviated.

"""
config_mark(;properties...) = _mkvis((:config, :mark), config_mark_spec, properties)


########### scale-level configuration ##############
config_scale_spec = Dict(
  :type     => AbstractString,
  :domain   => Vector,
  :range    => Vector,
  :round    => Bool,
  :bandSize => Real,
  :padding  => Real,
  :clamp    => Bool,
  :nice     => Union{Bool, AbstractString},
  :exponent => Real,
  :zero     => Bool
)


"""
Sets scale properties

config_scale(;properties...)


- `type` (`AbstractString`) :  ScaleType, one of "linear", "log", "pow", "sqrt", "quantile", "quantize", "ordinal", "time", "utc".
- `domain` (`AbstractString[]`) : The domain of the scale, representing the set of data values. For quantitative data, this can take the form of a two-element array with minimum and maximum values. For ordinal/categorical data, this may be an array of valid input values. The domain may also be specified by a reference to a data source.
- `range` (`AbstractString[]`) : The range of the scale, representing the set of visual values. For numeric values, the range can take the form of a two-element array with minimum and maximum values. For ordinal or quantized data, the range may by an array of desired output values, which are mapped to elements in the specified domain. For ordinal scales only, the range can be defined using a DataRef: the range values are then drawn dynamically from a backing data set.
- `round` (`Bool`) :  If true, rounds numeric output values to integers. This can be helpful for snapping to the pixel grid.

Ordinal

- `bandSize` (`Real`) : minimum 0
- `padding` (`Real`) : Applies spacing among ordinal elements in the scale range. The actual effect depends on how the scale is configured. If the __points__ parameter is `true`, the padding value is interpreted as a multiple of the spacing between points. A reasonable value is 1.0, such that the first and last point will be offset from the minimum and maximum value by half the distance between points. Otherwise, padding is typically in the range [0, 1] and corresponds to the fraction of space in the range interval to allocate to padding. A value of 0.5 means that the range band width will be equal to the padding width. For more, see the [D3 ordinal scale documentation](https://github.com/mbostock/d3/wiki/Ordinal-Scales).

Typical

- `clamp` (`Bool`) : If true, values that exceed the data domain are clamped to either the minimum or maximum range value
- `nice` (`Union{Bool, AbstractString}`) : If specified, modifies the scale domain to use a more human-friendly value range. If specified as a true boolean, modifies the scale domain to use a more human-friendly number range (e.g., 7 instead of 6.96). If specified as a string, modifies the scale domain to use a more human-friendly value range. For time and utc scale types only, the nice value should be a string indicating the desired time interval ("second", "minute", "hour", "day", "week", "month", "year").
- `exponent` (`Real`) : Sets the exponent of the scale transformation. For pow scale types only, otherwise ignored.
- `zero` (`Bool`) : If true, ensures that a zero baseline value is included in the scale domain. This option is ignored for non-quantitative scales.

"""
config_scale(;properties...) = _mkvis((:config, :scale), config_scale_spec, properties)


########### axis-level configuration ##############
config_axis_spec = Dict(
  :axisWidth       => Real,
  :layer           => AbstractString,
  :offset          => Real,
  :grid            => Bool,
  :labels          => Bool,
  :labelAngle      => Real,
  :labelAlign      => AbstractString,
  :labelBaseline   => AbstractString,
  :labelMaxLength  => Real,
  :shortTimeLabels => Bool,
  :subdivide       => Real,
  :ticks           => Real,
  :tickPadding     => Real,
  :tickSize        => Real,
  :tickSizeMajor   => Real,
  :tickSizeMinor   => Real,
  :tickSizeEnd     => Real,
  :titleOffset     => Real,
  :titleMaxLength  => Real,
  :characterWidth  => Real
)


"""
Sets axis properties

config_axis(;properties...)

General

- `axisWidth` (`Real`) : Width of the axis line
- `layer` (`AbstractString`) : A string indicating if the axis (and any gridlines) should be placed above or below the data marks.
- `offset` (`Real`) : The offset, in pixels, by which to displace the axis from the edge of the enclosing group or data rectangle.


Grid

- `grid` (`Bool`) : A flag indicate if gridlines should be created in addition to ticks. If `grid` is unspecified, the default value is `true` for ROW and COL. For X and Y, the default value is `true` for quantitative and time fields and `false` otherwise.


Labels

- `labels` (`Bool`) : Enable or disable labels.
- `labelAngle` (`Real`) : The rotation angle of the axis labels.
- `labelAlign` (`AbstractString`) : Text alignment for the Label.
- `labelBaseline` (`AbstractString`) : Text baseline for the label.
- `labelMaxLength` (`Real`) : Truncate labels that are too long.
- `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated.


Ticks

- `subdivide` (`Real`) : If provided, sets the number of minor ticks between major ticks (the value 9 results in decimal subdivision). Only applicable for axes visualizing quantitative scales.
- `ticks` (`Real`) : A desired number of ticks, for axes visualizing quantitative scales. The resulting number may be different so that values are "nice" (multiples of 2, 5, 10) and lie within the underlying scale's range.
- `tickPadding` (`Real`) : The padding, in pixels, between ticks and text labels.
- `tickSize` (`Real`) : The size, in pixels, of major, minor and end ticks.
- `tickSizeMajor` (`Real`) : The size, in pixels, of major ticks.
- `tickSizeMinor` (`Real`) : The size, in pixels, of minor ticks.
- `tickSizeEnd` (`Real`) : The size, in pixels, of end ticks.


Title

- `titleOffset` (`Real`) : A title offset value for the axis.
- `titleMaxLength` (`Real`) : Max length for axis title if the title is automatically generated from the field's description. By default, this is automatically based on cell size and characterWidth property.
- `characterWidth` (`Real`) : Character width for automatically determining title max length.
"""
config_axis(;properties...) = _mkvis((:config, :axis), config_axis_spec, properties)


########### facet configuration (general, axis, scale) ##############

"""
Sets facet cell properties, see ? config_cell
config_facet_cell(;properties...)
"""
config_facet_cell(;properties...) = _mkvis((:config, :facet, :cell), config_cell_spec, properties)


"""
Sets facet scale properties, see ? config_scale
config_facet_scale(;properties...)
"""
config_facet_scale(;properties...) = _mkvis((:config, :facet, :scale), config_scale_spec, properties)


"""
Sets facet axis properties, see ? config_axis
config_facet_axis(;properties...)
"""
config_facet_axis(;properties...) = _mkvis((:config, :facet, :axis), config_scale_spec, properties)




config_grid_spec = Dict(
  :gridColor   => AbstractString,
  :gridOpacity => Real,
  :gridOffset  => Real
)


"""
Sets facet grid properties

config_grid(;properties...)

- `gridColor` (`AbstractString`) : Color of the grid between facets.
- `gridOpacity` (`Real`) : Opacity of the grid between facets.
- `gridOffset` (`Real`) : Offset for grid between facets.
"""
config_grid(;properties...) = _mkvis((:config, :facet, :grid), config_grid_spec, properties)




"""
Legend Configuration (config.legend.*)

Legend configuration determines default properties for legends.

See Code: For a full list of legend configuration and their default values, please see the LegendConfig interface and defaultLegendConfig in legend.ts.

"""
