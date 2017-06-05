using Base.Test
using VegaLite

@test_throws ErrorException config(abcd="trus")
@test_throws ErrorException config(viewport="trus")
@test isa(config(viewport=[400,330]), VegaLiteVis)


xs = collect(linspace(0,2,100))
ys = Float64[ rand()*0.1 + cos(x) for x in xs]

@test isa(data_values(time=xs, res=ys), VegaLiteVis)
@test isa(mark_line(), VegaLiteVis)
@test isa(encoding_x_quant(:time), VegaLiteVis)
@test isa(encoding_y_quant(:res), VegaLiteVis)

using RDatasets
mpg = dataset("ggplot2", "mpg")

@test isa(data_values(mpg), VegaLiteVis)
@test isa(mark_point(), VegaLiteVis)

@test isa(encoding_x_quant(:Cty, axis=false), VegaLiteVis)
@test isa(encoding_y_quant(:Hwy, scale=scale(zero=false)), VegaLiteVis)
@test isa(encoding_color_nominal(:Manufacturer), VegaLiteVis)
@test isa(config_cell(width=350, height=400), VegaLiteVis)

@test isa(encoding_x_ord(:Year,
             axis  = axis(labelAngle=-45, labelAlign="right"),
             scale = scale(bandSize=50)), VegaLiteVis)

@test isa(encoding_column_ord(:Cyl), VegaLiteVis)
@test isa(encoding_row_ord(:Year), VegaLiteVis)

@test isa(encoding_x_quant(:Displ), VegaLiteVis)
@test isa(encoding_y_quant(:Hwy), VegaLiteVis)

@test isa(encoding_size_quant(:Cty), VegaLiteVis)

@test isa(mark_text(), VegaLiteVis)

@test isa(encoding_text_quant(:Displ, aggregate="mean"), VegaLiteVis)
@test isa(config_mark(fontStyle="italic", fontSize=12, font="courier"), VegaLiteVis)

include("test_io.jl")

println("Finished")
