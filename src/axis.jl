###################################################################
#  Axis related definitions & functions
###################################################################

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


axis_help = """
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

########### helper function for encoding()  ########
"""
Sets axis properties for the `axis` argument within `encoding()` :

```julia
encoding_x(..., axis=axis(subdivide=3), ...)
```

$axis_help
"""
axis(;properties...) = _mkdict(config_axis_spec, properties)

########### global level function ########
"""
Sets axis properties

`config_axis(;properties...)`

$axis_help
"""
config_axis(;properties...) = _mkvis((:config, :axis), config_axis_spec, properties)
