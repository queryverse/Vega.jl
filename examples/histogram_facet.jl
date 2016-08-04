using VegaLite
using DataFrames

## histograms by group

df= DataFrame(group=rand(0:1, 200))
df[:x] = df[:group]*2 + randn(size(df,1))

data_values(df) +
    mark_bar() +
    encoding_x_quant(:x; bin=Dict(:maxbins=>15)) +
    encoding_y_quant(:*, aggregate="count") +
    encoding_row_nominal(:group) +
    encoding_color_nominal(:group)
