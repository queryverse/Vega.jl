###################################################################
#  Mark-related definitions & functions
###################################################################

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



######## Mark type choice ################

mark_spec = Dict(:mark => AbstractString)


mark_bar()    = _mkvis(tuple(), mark_spec, [(:mark, "bar")])
mark_circle() = _mkvis(tuple(), mark_spec, [(:mark, "circle")])
mark_square() = _mkvis(tuple(), mark_spec, [(:mark, "square")])
mark_tick()   = _mkvis(tuple(), mark_spec, [(:mark, "tick")])
mark_line()   = _mkvis(tuple(), mark_spec, [(:mark, "line")])
mark_area()   = _mkvis(tuple(), mark_spec, [(:mark, "area")])
mark_point()  = _mkvis(tuple(), mark_spec, [(:mark, "point")])
mark_text()   = _mkvis(tuple(), mark_spec, [(:mark, "text")])
