using Base.Test
using VegaLite
using DataFrames

@testset "io" begin

p = DataFrame(x = [1,2,3], y=[1,2,3]) |> @vlplot(:point, x="x:q", y="y:q")
vgp = getvgplot()

Base.Filesystem.mktempdir() do folder
    svg(joinpath(folder,"test1.svg"), p)
    @test isfile(joinpath(folder,"test1.svg"))

    pdf(joinpath(folder,"test1.pdf"), p)
    @test isfile(joinpath(folder,"test1.pdf"))

    png(joinpath(folder,"test1.png"), p)
    @test isfile(joinpath(folder,"test1.png"))

    VegaLite.eps(joinpath(folder,"test1.eps"), p)
    @test isfile(joinpath(folder,"test1.eps"))

    savefig(joinpath(folder,"test2.svg"), p)
    @test isfile(joinpath(folder,"test2.svg"))

    savefig(joinpath(folder,"test2.pdf"), p)
    @test isfile(joinpath(folder,"test2.pdf"))

    savefig(joinpath(folder,"test2.png"), p)
    @test isfile(joinpath(folder,"test2.png"))

    savefig(joinpath(folder,"test2.eps"), p)
    @test isfile(joinpath(folder,"test2.eps"))

    save(joinpath(folder,"test2.svg"), p)
    @test isfile(joinpath(folder,"test2.svg"))

    save(joinpath(folder,"test2.pdf"), p)
    @test isfile(joinpath(folder,"test2.pdf"))

    save(joinpath(folder,"test2.png"), p)
    @test isfile(joinpath(folder,"test2.png"))

    save(joinpath(folder,"test2.eps"), p)
    @test isfile(joinpath(folder,"test2.eps"))

    save(joinpath(folder,"test4.svg"), vgp)
    @test isfile(joinpath(folder,"test4.svg"))

    save(joinpath(folder,"test4.pdf"), vgp)
    @test isfile(joinpath(folder,"test4.pdf"))

    save(joinpath(folder,"test4.png"), vgp)
    @test isfile(joinpath(folder,"test4.png"))

    save(joinpath(folder,"test4.eps"), vgp)
    @test isfile(joinpath(folder,"test4.eps"))

    VegaLite.savespec(joinpath(folder,"test1.vegalite"), p)
    @test isfile(joinpath(folder,"test1.vegalite"))

    @test_throws ArgumentError VegaLite.savefig(joinpath(folder,"test1.foo"), p)

    save(joinpath(folder,"test2.vegalite"), p)
    @test isfile(joinpath(folder,"test2.vegalite"))

    p2 = VegaLite.loadspec(joinpath(folder,"test1.vegalite"))
    @test isa(p2, VegaLite.VLSpec)

    p2 = load(joinpath(folder,"test1.vegalite"))
    @test isa(p2, VegaLite.VLSpec)

    vgpl1 = getvgplot()

    VegaLite.savevgspec(joinpath(folder,"test1.vega"), vgpl1, include_data=true)

    vgpl2 = VegaLite.loadvgspec(joinpath(folder,"test1.vega"))

    @test vgpl1.params == vgpl1.params

    # TODO Enable once FileIO stuff is merged
    # save(joinpath(folder,"test3.vega"), vgpl1)
    # @test isfile(joinpath(folder,"test3.vega"))

    # vgpl3 = load(joinpath(folder,"test3.vega"))
    # @test isa(vgpl2, VegaLite.VGSpec)

    # save(joinpath(folder,"test4.vega"), vgpl1, include_data=true)
    # @test isfile(joinpath(folder,"test4.vega"))

end

end
