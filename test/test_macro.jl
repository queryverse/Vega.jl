using Vega
using Vega:getparams
using JSON
using Test

@testset "macro" begin

    spec = vg"""
{
  "data": {
    "values": [
      {"a": "A","b": 28}, {"a": "B","b": 55}
    ]
  },
  "mark": "bar",
  "encoding": {
    "x": {"field": "a", "type": "ordinal"},
    "y": {"field": "b", "type": "quantitative"}
  }
}
"""

    @test isa(spec, Vega.VGSpec)
    @test getparams(spec) == JSON.parse("""
{
  "data": {
    "values": [
      {"a": "A","b": 28}, {"a": "B","b": 55}
    ]
  },
  "mark": "bar",
  "encoding": {
    "x": {"field": "a", "type": "ordinal"},
    "y": {"field": "b", "type": "quantitative"}
  }
}
""")

end
