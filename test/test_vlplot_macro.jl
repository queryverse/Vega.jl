using VegaLite
using FilePaths
using URIParser
using DataFrames
using Base.Test

@testset "@vlplot macro" begin

@test @vlplot(mark={"point"}).params == (vl"""
    {"mark": {"type": "point"}}
    """).params

@test @vlplot("point", data={values=[{a=1}]}).params == (vl"""
    {"mark": "point", "data": {"values":[{"a": 1}]}}
""").params

@test @vlplot(:point, x=:foo).params == @vlplot(:point, enc={x=:foo}).params

@test @vlplot(mark={typ=:point}).params == @vlplot(mark={:point}).params

@test (p"/foo/bar" |> @vlplot(:point)).params == @vlplot(:point, data=p"/foo/bar").params

@test (p"/foo/bar" |> @vlplot(:point)).params == @vlplot(:point, data={url=p"/foo/bar"}).params

@test (URI("http://foo.com/bar.json") |> @vlplot(:point)).params == @vlplot(:point, data=URI("http://foo.com/bar.json")).params

@test (URI("http://foo.com/bar.json") |> @vlplot(:point)).params == @vlplot(:point, data={url=URI("http://foo.com/bar.json")}).params

@test (DataFrame(a=[1]) |> @vlplot(:point)).params == @vlplot(:point, data=DataFrame(a=[1])).params

@test @vlplot("point", transform=[{lookup="foo", from={data=p"/foo/bar", key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "file://foo/bar"
@test @vlplot("point", transform=[{lookup="foo", from={data={url=p"/foo/bar"}, key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "file://foo/bar"
@test @vlplot("point", transform=[{lookup="foo", from={data=URI("http://foo.com/bar.json"), key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "http://foo.com/bar.json"
@test @vlplot("point", transform=[{lookup="foo", from={data={url=URI("http://foo.com/bar.json")}, key="bar"}}]).params["transform"][1]["from"]["data"]["url"] == "http://foo.com/bar.json"

@test @vlplot("point", transform=[{lookup="foo", from={data=DataFrame(a=[1]), key="bar"}}]).params["transform"][1]["from"]["data"]["values"][1]["a"] == 1

end
