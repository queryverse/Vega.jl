using Test
using Vega

@testset "show" begin

    vg = Vega.VGSpec(Dict{String,Any}())

    @test sprint(show, vg) == "Vega.VGSpec"

    @test sprint(show, "text/plain", vg) == "@vgplot(\n\n)"

    @test istextmime("application/vnd.vega.v5+json")


    @test sprint(show, "application/vnd.vega.v5+json", vg"{}") == "{}"

end
