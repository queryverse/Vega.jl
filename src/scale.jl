###################################################################
#  Scale related definitions & functions
###################################################################

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

scale_help = """

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

########### helper function for encoding()  ########
"""
Sets scale properties for the scale argument within `encoding()` :

```julia
encoding_x(..., scale=scale(round=true, bandSize=12), ...)
```

$scale_help
"""
scale(;properties...) = _mkdict(config_scale_spec, properties)

########### config function ########
"""
Sets scale properties

`config_scale(;properties...)`

$scale_help
"""
config_scale(;properties...) = _mkvis((:config, :scale), config_scale_spec, properties)
