using VegaLite
using DataFrames

# a simple histogram of random standard normal draws

data_values(DataFrame(x=randn(200))) +
    mark_bar() +
    encoding_x_quant(:x; bin=Dict(:maxbins=>20), axis=Dict(:title=>"values")) +
    encoding_y_quant(:*, aggregate="count", axis=Dict(:title=>"number of draws"))
