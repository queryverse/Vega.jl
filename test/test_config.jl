using Test
using Vega

@testset "Config" begin

    @test isa(renderer(), Symbol)
    @test_throws MethodError renderer(456)
    @test_throws ErrorException renderer(:abcd)
    renderer(:canvas)
    @test renderer() == :canvas

    @test isa(actionlinks(), Bool)
    @test_throws MethodError actionlinks(46)
    actionlinks(false)
    @test actionlinks() == false

end
