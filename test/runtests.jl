using Base.Test
using VegaLite

@testset "VegaLite" begin

include("test_io.jl")
include("test_base.jl")
include("test_macro.jl")
include("test_shorthand.jl")
include("test_spec.jl")

end
