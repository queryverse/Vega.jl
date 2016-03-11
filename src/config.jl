###################################################################
#  configuration options
#
#  config(), config_cell(),
###################################################################


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

cell_help = """

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


"""
Sets cell properties
`config_cell(;properties...)`

$cell_help
"""
config_cell(;properties...) = _mkvis((:config, :cell), config_cell_spec, properties)



########### facet configuration (general, axis, scale) ##############

"""
Sets facet cell properties,
`config_facet_cell(;properties...)`

$cell_help
"""
config_facet_cell(;properties...) = _mkvis((:config, :facet, :cell), config_cell_spec, properties)


"""
Sets facet scale properties,
`config_facet_scale(;properties...)`

$scale_help
"""
config_facet_scale(;properties...) = _mkvis((:config, :facet, :scale), config_scale_spec, properties)


"""
Sets facet axis properties, see ? config_axis
`config_facet_axis(;properties...)`

$axis_help
"""
config_facet_axis(;properties...) = _mkvis((:config, :facet, :axis), config_axis_spec, properties)



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
