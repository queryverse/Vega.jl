using Test
using VegaLite

@testset "properties" begin

vgp = getvgplot()
@test vgp.width isa Number
@static if VERSION >= v"1.3"
    @test vgp.var"$schema" isa String
end

vlp = getvlplot()
@test vlp.mark isa String
@test vlp.encoding.x.field isa String

end
