using Test
using Vega
using Setfield

@testset "properties" begin

    vgp = getvgplot()
    @test vgp.width isa Number
    @static if VERSION >= v"1.3"
        @test vgp.var"$schema" isa String
    end

end
