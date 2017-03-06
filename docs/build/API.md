
<a id='API-1'></a>

## API


<a id='data_values-1'></a>

### data_values

<a id='VegaLite.data_values-Tuple{}' href='#VegaLite.data_values-Tuple{}'>#</a>
**`VegaLite.data_values`** &mdash; *Method*.



Sets the data source data_values(*sym1*=*vec1*, *sym2*=*vec2*, ...)

Adds data vectors (`vec1`, `vec1`,..) and binds each of them to a symbol (`sym1`, `sym2`, ...)


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/data_values.jl#L2-L7' class='documenter-source'>source</a><br>


<a id='config-1'></a>

### config

<a id='VegaLite.config-Tuple{}' href='#VegaLite.config-Tuple{}'>#</a>
**`VegaLite.config`** &mdash; *Method*.



Sets top-level properties config(;properties...)

  * `viewport` (`Vector{Real}`) : The width and height of the on-screen viewport, in pixels. If necessary, clipping and scrolling will be applied. Default value: (none)
  * `background` (`AbstractString`) : CSS color property to use as background of visualization. Default value: (none)
  * `timeFormat` (`AbstractString`) : The default time format pattern for text and labels of axes and legends (in the form of D3 time format pattern). Default value: '%Y-%m-%d'.
  * `numberFormat` (`AbstractString`) : The default number format pattern for text and labels of axes and legends (in the form of D3 number format pattern). Default value: 's'.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L18-L26' class='documenter-source'>source</a><br>

<a id='VegaLite.config_cell-Tuple{}' href='#VegaLite.config_cell-Tuple{}'>#</a>
**`VegaLite.config_cell`** &mdash; *Method*.



Sets cell properties `config_cell(;properties...)`

  * `width` (`Real`) :	The width of the single plot or each plot in a trellis plot when the visualization has continuous x-scale. (If the plot has ordinal x-scale, the width is determined by the x-scale’s bandSize and the cardinality of the x-scale. If the plot does not have a field on x, the width is derived from scale config’s bandSize for all marks except text and from scale config’s textBandWidth for text mark.) Default value: 200
  * `height` (`Real`) :	The height of the single plot or each plot in a trellis plot when the visualization has continuous y-scale. (If the visualization has ordinal y-scale, the height is determined by the bandSize and the cardinality of the y-scale. If the plot does not have a field on y, the height is scale config’s bandSize.) Default value: 200
  * `fill` (`AbstractString`) :	The fill color. Default value: (none)
  * `fillOpacity` (`Real`) :	The fill opacity (value between [0,1]). Default value: (none)
  * `stroke` (`AbstractString`) :	The stroke color. Default value: (none)
  * `strokeOpacity` (`Real`) :	The stroke opacity (value between [0,1]). Default value: (none)
  * `strokeWidth` (`Number`) :	The stroke width, in pixels. Default value: (none)
  * `strokeDash` (`Vector{Real}`) : An array of alternating stroke, space lengths for creating dashed or dotted lines. Default value: (none)
  * `strokeDashOffset` (`Vector{Real}`) : The offset (in pixels) into which to begin drawing with the stroke dash array. Default value: (none)


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L59-L64' class='documenter-source'>source</a><br>

<a id='VegaLite.config_facet_cell-Tuple{}' href='#VegaLite.config_facet_cell-Tuple{}'>#</a>
**`VegaLite.config_facet_cell`** &mdash; *Method*.



Sets facet cell properties, `config_facet_cell(;properties...)`

  * `width` (`Real`) :	The width of the single plot or each plot in a trellis plot when the visualization has continuous x-scale. (If the plot has ordinal x-scale, the width is determined by the x-scale’s bandSize and the cardinality of the x-scale. If the plot does not have a field on x, the width is derived from scale config’s bandSize for all marks except text and from scale config’s textBandWidth for text mark.) Default value: 200
  * `height` (`Real`) :	The height of the single plot or each plot in a trellis plot when the visualization has continuous y-scale. (If the visualization has ordinal y-scale, the height is determined by the bandSize and the cardinality of the y-scale. If the plot does not have a field on y, the height is scale config’s bandSize.) Default value: 200
  * `fill` (`AbstractString`) :	The fill color. Default value: (none)
  * `fillOpacity` (`Real`) :	The fill opacity (value between [0,1]). Default value: (none)
  * `stroke` (`AbstractString`) :	The stroke color. Default value: (none)
  * `strokeOpacity` (`Real`) :	The stroke opacity (value between [0,1]). Default value: (none)
  * `strokeWidth` (`Number`) :	The stroke width, in pixels. Default value: (none)
  * `strokeDash` (`Vector{Real}`) : An array of alternating stroke, space lengths for creating dashed or dotted lines. Default value: (none)
  * `strokeDashOffset` (`Vector{Real}`) : The offset (in pixels) into which to begin drawing with the stroke dash array. Default value: (none)


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L71-L76' class='documenter-source'>source</a><br>

<a id='VegaLite.config_grid-Tuple{}' href='#VegaLite.config_grid-Tuple{}'>#</a>
**`VegaLite.config_grid`** &mdash; *Method*.



Sets facet grid properties

config_grid(;properties...)

  * `gridColor` (`AbstractString`) : Color of the grid between facets.
  * `gridOpacity` (`Real`) : Opacity of the grid between facets.
  * `gridOffset` (`Real`) : Offset for grid between facets.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L106-L114' class='documenter-source'>source</a><br>


<a id='axis-1'></a>

### axis

<a id='VegaLite.axis-Tuple{}' href='#VegaLite.axis-Tuple{}'>#</a>
**`VegaLite.axis`** &mdash; *Method*.



Sets axis properties for the `axis` argument within `encoding()` :

```julia
encoding_x(..., axis=axis(subdivide=3), ...)
```

General

  * `axisWidth` (`Real`) : Width of the axis line
  * `layer` (`AbstractString`) : A string indicating if the axis (and any gridlines) should be placed above or below the data marks.
  * `offset` (`Real`) : The offset, in pixels, by which to displace the axis from the edge of the enclosing group or data rectangle.

Grid

  * `grid` (`Bool`) : A flag indicate if gridlines should be created in addition to ticks. If `grid` is unspecified, the default value is `true` for ROW and COL. For X and Y, the default value is `true` for quantitative and time fields and `false` otherwise.

Labels

  * `labels` (`Bool`) : Enable or disable labels.
  * `labelAngle` (`Real`) : The rotation angle of the axis labels.
  * `labelAlign` (`AbstractString`) : Text alignment for the Label.
  * `labelBaseline` (`AbstractString`) : Text baseline for the label.
  * `labelMaxLength` (`Real`) : Truncate labels that are too long.
  * `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated.

Ticks

  * `subdivide` (`Real`) : If provided, sets the number of minor ticks between major ticks (the value 9 results in decimal subdivision). Only applicable for axes visualizing quantitative scales.
  * `ticks` (`Real`) : A desired number of ticks, for axes visualizing quantitative scales. The resulting number may be different so that values are "nice" (multiples of 2, 5, 10) and lie within the underlying scale's range.
  * `tickPadding` (`Real`) : The padding, in pixels, between ticks and text labels.
  * `tickSize` (`Real`) : The size, in pixels, of major, minor and end ticks.
  * `tickSizeMajor` (`Real`) : The size, in pixels, of major ticks.
  * `tickSizeMinor` (`Real`) : The size, in pixels, of minor ticks.
  * `tickSizeEnd` (`Real`) : The size, in pixels, of end ticks.

Title

  * `titleOffset` (`Real`) : A title offset value for the axis.
  * `titleMaxLength` (`Real`) : Max length for axis title if the title is automatically generated from the field's description. By default, this is automatically based on cell size and characterWidth property.
  * `characterWidth` (`Real`) : Character width for automatically determining title max length.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/axis.jl#L71-L79' class='documenter-source'>source</a><br>

<a id='VegaLite.config_axis-Tuple{}' href='#VegaLite.config_axis-Tuple{}'>#</a>
**`VegaLite.config_axis`** &mdash; *Method*.



Sets axis properties

`config_axis(;properties...)`

General

  * `axisWidth` (`Real`) : Width of the axis line
  * `layer` (`AbstractString`) : A string indicating if the axis (and any gridlines) should be placed above or below the data marks.
  * `offset` (`Real`) : The offset, in pixels, by which to displace the axis from the edge of the enclosing group or data rectangle.

Grid

  * `grid` (`Bool`) : A flag indicate if gridlines should be created in addition to ticks. If `grid` is unspecified, the default value is `true` for ROW and COL. For X and Y, the default value is `true` for quantitative and time fields and `false` otherwise.

Labels

  * `labels` (`Bool`) : Enable or disable labels.
  * `labelAngle` (`Real`) : The rotation angle of the axis labels.
  * `labelAlign` (`AbstractString`) : Text alignment for the Label.
  * `labelBaseline` (`AbstractString`) : Text baseline for the label.
  * `labelMaxLength` (`Real`) : Truncate labels that are too long.
  * `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated.

Ticks

  * `subdivide` (`Real`) : If provided, sets the number of minor ticks between major ticks (the value 9 results in decimal subdivision). Only applicable for axes visualizing quantitative scales.
  * `ticks` (`Real`) : A desired number of ticks, for axes visualizing quantitative scales. The resulting number may be different so that values are "nice" (multiples of 2, 5, 10) and lie within the underlying scale's range.
  * `tickPadding` (`Real`) : The padding, in pixels, between ticks and text labels.
  * `tickSize` (`Real`) : The size, in pixels, of major, minor and end ticks.
  * `tickSizeMajor` (`Real`) : The size, in pixels, of major ticks.
  * `tickSizeMinor` (`Real`) : The size, in pixels, of minor ticks.
  * `tickSizeEnd` (`Real`) : The size, in pixels, of end ticks.

Title

  * `titleOffset` (`Real`) : A title offset value for the axis.
  * `titleMaxLength` (`Real`) : Max length for axis title if the title is automatically generated from the field's description. By default, this is automatically based on cell size and characterWidth property.
  * `characterWidth` (`Real`) : Character width for automatically determining title max length.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/axis.jl#L83-L89' class='documenter-source'>source</a><br>

<a id='VegaLite.config_facet_axis-Tuple{}' href='#VegaLite.config_facet_axis-Tuple{}'>#</a>
**`VegaLite.config_facet_axis`** &mdash; *Method*.



Sets facet axis properties, see ? config_axis `config_facet_axis(;properties...)`

General

  * `axisWidth` (`Real`) : Width of the axis line
  * `layer` (`AbstractString`) : A string indicating if the axis (and any gridlines) should be placed above or below the data marks.
  * `offset` (`Real`) : The offset, in pixels, by which to displace the axis from the edge of the enclosing group or data rectangle.

Grid

  * `grid` (`Bool`) : A flag indicate if gridlines should be created in addition to ticks. If `grid` is unspecified, the default value is `true` for ROW and COL. For X and Y, the default value is `true` for quantitative and time fields and `false` otherwise.

Labels

  * `labels` (`Bool`) : Enable or disable labels.
  * `labelAngle` (`Real`) : The rotation angle of the axis labels.
  * `labelAlign` (`AbstractString`) : Text alignment for the Label.
  * `labelBaseline` (`AbstractString`) : Text baseline for the label.
  * `labelMaxLength` (`Real`) : Truncate labels that are too long.
  * `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated.

Ticks

  * `subdivide` (`Real`) : If provided, sets the number of minor ticks between major ticks (the value 9 results in decimal subdivision). Only applicable for axes visualizing quantitative scales.
  * `ticks` (`Real`) : A desired number of ticks, for axes visualizing quantitative scales. The resulting number may be different so that values are "nice" (multiples of 2, 5, 10) and lie within the underlying scale's range.
  * `tickPadding` (`Real`) : The padding, in pixels, between ticks and text labels.
  * `tickSize` (`Real`) : The size, in pixels, of major, minor and end ticks.
  * `tickSizeMajor` (`Real`) : The size, in pixels, of major ticks.
  * `tickSizeMinor` (`Real`) : The size, in pixels, of minor ticks.
  * `tickSizeEnd` (`Real`) : The size, in pixels, of end ticks.

Title

  * `titleOffset` (`Real`) : A title offset value for the axis.
  * `titleMaxLength` (`Real`) : Max length for axis title if the title is automatically generated from the field's description. By default, this is automatically based on cell size and characterWidth property.
  * `characterWidth` (`Real`) : Character width for automatically determining title max length.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L89-L94' class='documenter-source'>source</a><br>


<a id='encoding-1'></a>

### encoding


```
encoding_color_nominal()
```


<a id='legend-1'></a>

### legend

<a id='VegaLite.legend-Tuple{}' href='#VegaLite.legend-Tuple{}'>#</a>
**`VegaLite.legend`** &mdash; *Method*.



Sets legend properties for the `legend` argument within `encoding()` :

```julia
encoding_x(..., legend=legend(orient="left"), ...)
```

  * `orient` (`AbstractString`) : The orientation of the legend. One of "left" or "right". This determines how the legend is positioned within the scene. Default value: derived from legend config’s orient ("right" by default).
  * `title` (`AbstractString`) : The title for the legend. Default value: derived from the field’s name and transformation function applied e.g, “field_name”, “SUM(field_name)”, “BIN(field_name)”, “YEAR(field_name)”.
  * `format` (`AbstractString`) : The formatting pattern for axis labels. This is D3’s number format pattern for quantitative axis and D3’s time format pattern for time axis. Default value: derived from numberFormat config for quantitative axis and from timeFormat config for time axis.
  * `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated. Default value: derived from legend config’s shortTimeLabels (false by default).
  * `values` (`Vector{AbstractString}`) : Explicitly set the visible legend values.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/legend.jl#L24-L32' class='documenter-source'>source</a><br>

<a id='VegaLite.config_legend' href='#VegaLite.config_legend'>#</a>
**`VegaLite.config_legend`** &mdash; *Function*.



Sets legend properties

`config_legend(;properties...)`

  * `orient` (`AbstractString`) : The orientation of the legend. One of "left" or "right". This determines how the legend is positioned within the scene. Default value: derived from legend config’s orient ("right" by default).
  * `title` (`AbstractString`) : The title for the legend. Default value: derived from the field’s name and transformation function applied e.g, “field_name”, “SUM(field_name)”, “BIN(field_name)”, “YEAR(field_name)”.
  * `format` (`AbstractString`) : The formatting pattern for axis labels. This is D3’s number format pattern for quantitative axis and D3’s time format pattern for time axis. Default value: derived from numberFormat config for quantitative axis and from timeFormat config for time axis.
  * `shortTimeLabels` (`Bool`) : Whether month and day names should be abbreviated. Default value: derived from legend config’s shortTimeLabels (false by default).
  * `values` (`Vector{AbstractString}`) : Explicitly set the visible legend values.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/legend.jl#L37-L43' class='documenter-source'>source</a><br>


<a id='mark-1'></a>

### mark


```
mark_bar()
config_mark()
```


<a id='scale-1'></a>

### scale

<a id='Base.scale-Tuple{}' href='#Base.scale-Tuple{}'>#</a>
**`Base.scale`** &mdash; *Method*.



Sets scale properties for the scale argument within `encoding()` :

```julia
encoding_x(..., scale=scale(round=true, bandSize=12), ...)
```

  * `type` (`AbstractString`) :  ScaleType, one of "linear", "log", "pow", "sqrt", "quantile", "quantize", "ordinal", "time", "utc".
  * `domain` (`AbstractString[]`) : The domain of the scale, representing the set of data values. For quantitative data, this can take the form of a two-element array with minimum and maximum values. For ordinal/categorical data, this may be an array of valid input values. The domain may also be specified by a reference to a data source.
  * `range` (`AbstractString[]`) : The range of the scale, representing the set of visual values. For numeric values, the range can take the form of a two-element array with minimum and maximum values. For ordinal or quantized data, the range may by an array of desired output values, which are mapped to elements in the specified domain. For ordinal scales only, the range can be defined using a DataRef: the range values are then drawn dynamically from a backing data set.
  * `round` (`Bool`) :  If true, rounds numeric output values to integers. This can be helpful for snapping to the pixel grid.

Ordinal

  * `bandSize` (`Real`) : minimum 0
  * `padding` (`Real`) : Applies spacing among ordinal elements in the scale range. The actual effect depends on how the scale is configured. If the __points__ parameter is `true`, the padding value is interpreted as a multiple of the spacing between points. A reasonable value is 1.0, such that the first and last point will be offset from the minimum and maximum value by half the distance between points. Otherwise, padding is typically in the range [0, 1] and corresponds to the fraction of space in the range interval to allocate to padding. A value of 0.5 means that the range band width will be equal to the padding width. For more, see the [D3 ordinal scale documentation](https://github.com/mbostock/d3/wiki/Ordinal-Scales).

Typical

  * `clamp` (`Bool`) : If true, values that exceed the data domain are clamped to either the minimum or maximum range value
  * `nice` (`Union{Bool, AbstractString}`) : If specified, modifies the scale domain to use a more human-friendly value range. If specified as a true boolean, modifies the scale domain to use a more human-friendly number range (e.g., 7 instead of 6.96). If specified as a string, modifies the scale domain to use a more human-friendly value range. For time and utc scale types only, the nice value should be a string indicating the desired time interval ("second", "minute", "hour", "day", "week", "month", "year").
  * `exponent` (`Real`) : Sets the exponent of the scale transformation. For pow scale types only, otherwise ignored.
  * `zero` (`Bool`) : If true, ensures that a zero baseline value is included in the scale domain. This option is ignored for non-quantitative scales.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/scale.jl#L39-L47' class='documenter-source'>source</a><br>

<a id='VegaLite.config_scale-Tuple{}' href='#VegaLite.config_scale-Tuple{}'>#</a>
**`VegaLite.config_scale`** &mdash; *Method*.



Sets scale properties

`config_scale(;properties...)`

  * `type` (`AbstractString`) :  ScaleType, one of "linear", "log", "pow", "sqrt", "quantile", "quantize", "ordinal", "time", "utc".
  * `domain` (`AbstractString[]`) : The domain of the scale, representing the set of data values. For quantitative data, this can take the form of a two-element array with minimum and maximum values. For ordinal/categorical data, this may be an array of valid input values. The domain may also be specified by a reference to a data source.
  * `range` (`AbstractString[]`) : The range of the scale, representing the set of visual values. For numeric values, the range can take the form of a two-element array with minimum and maximum values. For ordinal or quantized data, the range may by an array of desired output values, which are mapped to elements in the specified domain. For ordinal scales only, the range can be defined using a DataRef: the range values are then drawn dynamically from a backing data set.
  * `round` (`Bool`) :  If true, rounds numeric output values to integers. This can be helpful for snapping to the pixel grid.

Ordinal

  * `bandSize` (`Real`) : minimum 0
  * `padding` (`Real`) : Applies spacing among ordinal elements in the scale range. The actual effect depends on how the scale is configured. If the __points__ parameter is `true`, the padding value is interpreted as a multiple of the spacing between points. A reasonable value is 1.0, such that the first and last point will be offset from the minimum and maximum value by half the distance between points. Otherwise, padding is typically in the range [0, 1] and corresponds to the fraction of space in the range interval to allocate to padding. A value of 0.5 means that the range band width will be equal to the padding width. For more, see the [D3 ordinal scale documentation](https://github.com/mbostock/d3/wiki/Ordinal-Scales).

Typical

  * `clamp` (`Bool`) : If true, values that exceed the data domain are clamped to either the minimum or maximum range value
  * `nice` (`Union{Bool, AbstractString}`) : If specified, modifies the scale domain to use a more human-friendly value range. If specified as a true boolean, modifies the scale domain to use a more human-friendly number range (e.g., 7 instead of 6.96). If specified as a string, modifies the scale domain to use a more human-friendly value range. For time and utc scale types only, the nice value should be a string indicating the desired time interval ("second", "minute", "hour", "day", "week", "month", "year").
  * `exponent` (`Real`) : Sets the exponent of the scale transformation. For pow scale types only, otherwise ignored.
  * `zero` (`Bool`) : If true, ensures that a zero baseline value is included in the scale domain. This option is ignored for non-quantitative scales.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/scale.jl#L51-L57' class='documenter-source'>source</a><br>

<a id='VegaLite.config_facet_scale-Tuple{}' href='#VegaLite.config_facet_scale-Tuple{}'>#</a>
**`VegaLite.config_facet_scale`** &mdash; *Method*.



Sets facet scale properties, `config_facet_scale(;properties...)`

  * `type` (`AbstractString`) :  ScaleType, one of "linear", "log", "pow", "sqrt", "quantile", "quantize", "ordinal", "time", "utc".
  * `domain` (`AbstractString[]`) : The domain of the scale, representing the set of data values. For quantitative data, this can take the form of a two-element array with minimum and maximum values. For ordinal/categorical data, this may be an array of valid input values. The domain may also be specified by a reference to a data source.
  * `range` (`AbstractString[]`) : The range of the scale, representing the set of visual values. For numeric values, the range can take the form of a two-element array with minimum and maximum values. For ordinal or quantized data, the range may by an array of desired output values, which are mapped to elements in the specified domain. For ordinal scales only, the range can be defined using a DataRef: the range values are then drawn dynamically from a backing data set.
  * `round` (`Bool`) :  If true, rounds numeric output values to integers. This can be helpful for snapping to the pixel grid.

Ordinal

  * `bandSize` (`Real`) : minimum 0
  * `padding` (`Real`) : Applies spacing among ordinal elements in the scale range. The actual effect depends on how the scale is configured. If the __points__ parameter is `true`, the padding value is interpreted as a multiple of the spacing between points. A reasonable value is 1.0, such that the first and last point will be offset from the minimum and maximum value by half the distance between points. Otherwise, padding is typically in the range [0, 1] and corresponds to the fraction of space in the range interval to allocate to padding. A value of 0.5 means that the range band width will be equal to the padding width. For more, see the [D3 ordinal scale documentation](https://github.com/mbostock/d3/wiki/Ordinal-Scales).

Typical

  * `clamp` (`Bool`) : If true, values that exceed the data domain are clamped to either the minimum or maximum range value
  * `nice` (`Union{Bool, AbstractString}`) : If specified, modifies the scale domain to use a more human-friendly value range. If specified as a true boolean, modifies the scale domain to use a more human-friendly number range (e.g., 7 instead of 6.96). If specified as a string, modifies the scale domain to use a more human-friendly value range. For time and utc scale types only, the nice value should be a string indicating the desired time interval ("second", "minute", "hour", "day", "week", "month", "year").
  * `exponent` (`Real`) : Sets the exponent of the scale transformation. For pow scale types only, otherwise ignored.
  * `zero` (`Bool`) : If true, ensures that a zero baseline value is included in the scale domain. This option is ignored for non-quantitative scales.


<a target='_blank' href='https://github.com/fredo-dedup/VegaLite.jl/tree/23bdedb68724137829e627462a56cc67b211e22d/src/config.jl#L80-L85' class='documenter-source'>source</a><br>

