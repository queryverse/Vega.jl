###################################################################
#  Legend related definitions & functions
###################################################################

config_legend_spec = Dict(
  :orient          => AbstractString,
  :title           => AbstractString,
  :format          => AbstractString,
  :shortTimeLabels => Bool,
  :values          => Vector
)


legend_help = """

- `orient` (`AbstractString`) : The orientation of the legend. One of "left" or "right". This determines how the legend is positioned within the scene. Default value: derived from legend config’s orient ("right" by default).
- `title` (`AbstractString`) : The title for the legend. Default value: derived from the field’s name and transformation function applied e.g, “field_name”, “SUM(field_name)”, “BIN(field_name)”, “YEAR(field_name)”.
- `format` (`AbstractString`) : The formatting pattern for axis labels. This is D3’s number format pattern for quantitative axis and D3’s time format pattern for time axis. Default value: derived from numberFormat config for quantitative axis and from timeFormat config for time axis.
- `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated. Default value: derived from legend config’s shortTimeLabels (false by default).
- `values` (`Vector{AbstractString}`) : Explicitly set the visible legend values.
"""

########### helper function for encoding()  ########
"""
Sets legend properties for the `legend` argument within `encoding()` :

```julia
encoding_x(..., legend=legend(orient="left"), ...)
```

$legend_help
"""
legend(;properties...) = _mkdict(config_legend_spec, properties)


########### global level function ########
"""
Sets legend properties

`config_legend(;properties...)`

$legend_help
"""
config_legend(;properties...) = _mkvis((:config, :legend), config_legend_spec, properties)
