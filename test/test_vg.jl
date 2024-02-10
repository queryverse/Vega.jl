@testitem "VGSpec" begin
    using URIParser
    using FilePaths
    using DataFrames
    using VegaDatasets
    using Dates
    using Vega: getparams

    include("testhelper_create_vg_plot.jl")

    @test vg"""{ "data": [ { "name": "test" } ] }"""(URI("http://www.foo.com/bar.json"), "test") == vg"""
        {
            "data": [{
                "name": "test",
                "url": "http://www.foo.com/bar.json"
            }]
        }
        """

    if Sys.iswindows()
        @test vg"""{ "data": [ { "name": "test" } ] }"""(Path("/julia/dev"), "test") == vg"""
            {
                "data": [{
                    "name": "test",
                    "url": "file://julia/dev"
                }]
            }
            """
    else
        @test vg"""{ "data": [ { "name": "test" } ] }"""(Path("/julia/dev"), "test") == vg"""
            {
                "data": [{
                    "name": "test",
                    "url": "file:///julia/dev"
                }]
            }
            """
    end

    df = DataFrame(a=[1., 2.], b=["A", "B"], c=[Date(2000), Date(2001)])

    p1 = getvgplot()

    p2 = deletedata(p1)
    @test !haskey(getparams(p2)["data"][1], "values")

    p3 = p2(df, "table")

    @test getparams(p3)["data"][1]["values"][1]["b"] == "A"

    deletedata!(p1)

    @test p1 == p2

end
