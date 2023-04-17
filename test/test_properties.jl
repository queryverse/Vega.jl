@testitem "properties" begin
    using Setfield

    include("testhelper_create_vg_plot.jl")
    
    vgp = getvgplot()
    @test vgp.width isa Number
    @static if VERSION >= v"1.3"
        @test vgp.var"$schema" isa String
    end
end
