using Base.Test
using Compat
using VegaLite

p = data_values(x = [1,2,3], y=[1,2,3]) +
    mark_point() +
    encoding_x_quant(:x) +
    encoding_y_quant(:y)

Compat.Filesystem.mktempdir() do folder   
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

end
