using Base.Test
using VegaLite

@testset "VegaLite" begin

include("test_io.jl")
include("test_base.jl")
include("test_macro.jl")

end
