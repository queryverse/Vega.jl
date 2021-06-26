using Test
using Vega
using Vega:getparams
using DataFrames
using Dates
using FileIO

@testset "io" begin

    vgp = getvgplot()

# @testset "$fmt (indent=$(repr(indent)))" for (fmt, plt) in [
#     (format"vegalite", vlp)
#     # (format"vega", vgp)  # waiting for FileIO
# ],
#     indent in [nothing, 4]

#     let json = sprint(io -> save(Stream(fmt, io), plt, indent=indent)),
#         code = "vg\"\"\"$json\"\"\""
#         @test getparams(include_string(@__MODULE__, code)) == getparams(plt)
#     end

#     let io = IOBuffer()
#         save(Stream(fmt, io), plt, indent=indent)
#         seek(io, 0)
#         @test getparams(load(Stream(fmt, io))) == getparams(plt)
#     end

#     let code = repr("text/plain", plt, context=:compact=>false)
#         @test getparams(include_string(@__MODULE__, code)) == getparams(plt)
#     end
# end

    Base.Filesystem.mktempdir() do folder
        save(joinpath(folder, "test4.svg"), vgp)
        @test isfile(joinpath(folder, "test4.svg"))

        save(joinpath(folder, "test4.pdf"), vgp)
        @test isfile(joinpath(folder, "test4.pdf"))

        save(joinpath(folder, "test4.png"), vgp)
        @test isfile(joinpath(folder, "test4.png"))

    # save(joinpath(folder,"test4.eps"), vgp)
    # @test isfile(joinpath(folder,"test4.eps"))

        vgpl1 = getvgplot()

        Vega.savespec(joinpath(folder, "test1.vega"), vgpl1, include_data=true)

        vgpl2 = Vega.loadvgspec(joinpath(folder, "test1.vega"))

        @test vgpl1 == vgpl1

    # TODO Enable once FileIO stuff is merged
    # save(joinpath(folder,"test3.vega"), vgpl1)
    # @test isfile(joinpath(folder,"test3.vega"))

    # vgpl3 = load(joinpath(folder,"test3.vega"))
    # @test isa(vgpl2, VegaLite.VGSpec)

    # save(joinpath(folder,"test4.vega"), vgpl1, include_data=true)
    # @test isfile(joinpath(folder,"test4.vega"))

    end

end
