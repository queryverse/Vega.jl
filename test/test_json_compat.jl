@testitem "json compat" begin
    using DataFrames
    using JSON
    using Vega: getparams

    include("testhelper_create_vg_plot.jl")

    # Key order of the original document must survive parsing.
    spec = vg"""{"width": 1, "height": 2, "padding": 3}"""
    @test collect(keys(getparams(spec))) == ["width", "height", "padding"]

    # JSON has no NaN/Inf, so they have to come out as `null`.
    df = DataFrame(a=[1.0, NaN, Inf, -Inf], b=["A", "B", "C", "D"])

    # Inline data is held as a `DataValuesNode`, which has its own writer.
    p1 = @vgplot(data = [{name = "table", values = df}])
    @test getparams(p1)["data"][1]["values"] isa Vega.DataValuesNode

    # Data passed to an existing spec ends up as plain dictionaries instead.
    p2 = deletedata(getvgplot())(df, "table")
    @test getparams(p2)["data"][1]["values"] isa AbstractVector{<:AbstractDict}

    for p in [p1, p2]
        values = JSON.parse(sprint(Vega.our_json_print, p))["data"][1]["values"]

        @test [row["a"] for row in values] == [1.0, nothing, nothing, nothing]
        @test [row["b"] for row in values] == ["A", "B", "C", "D"]

        # `savespec` writes the spec itself rather than going through
        # `our_json_print`, both compact and pretty printed.
        for indent in [nothing, 4]
            written = sprint(io -> Vega.savespec(io, p, include_data=true, indent=indent))
            @test JSON.parse(written)["data"][1]["values"][2]["a"] === nothing
        end
    end
end
