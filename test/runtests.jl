using Test
using Vega
using Dates

@testset "Vega" begin

    include("testhelper_create_vg_plot.jl")
    include("test_io.jl")
    include("test_show.jl")
    include("test_config.jl")
    include("test_macro.jl")
    include("test_vg.jl")
    include("test_properties.jl")

end
