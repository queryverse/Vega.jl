using Base.Test
using VegaLite
using URIParser
using FilePaths
using DataFrames

@testset "Spec" begin

@test @vlplot()(URI("http://www.foo.com/bar.json")).params == vl"""
    {
        "data": {
            "url": "http://www.foo.com/bar.json"
        }
    }
    """.params

@test_throws ArgumentError @vlplot()(5)

df = DataFrame(a=[1.,2.], b=["A", "B"], c=[Date(2000), Date(2001)])

p1 = (df |> @vlplot("line", x=:c, y=:a, color=:b))
p2 = vl"""
{
  "encoding": {
    "x": {
      "field": "c",
      "type": "temporal"
    },
    "color": {
      "field": "b",
      "type": "nominal"
    },
    "y": {
      "field": "a",
      "type": "quantitative"
    }
  },
  "mark": "line"
}
"""

delete!(p1.params, "data")

@test p1.params == p2.params

end
