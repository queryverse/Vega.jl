# Using Vega

A Vega plot specification is represented as a `VGSpec` object in Julia. There are multiple ways to create a `VGSpec` object:

1. The `@vgplot` macro is the main way to create `VGSpec` instances in code.
2. Using the `vg` string macro, you can write Vega specifications as JSON in your Julia code.
3. You can load Vega specifications from disc with the `load` function.

There are two main things one can do with a `VGSpec` object:

1. One can display it in various front ends.
2. One can save the plot to disc in various formats using the save function.

This section will give a brief overview of these options.

## The `@vgplot` macro

The `@vgplot` macro is the main way to specify Vega plots in [VegaLite.jl](https://github.com/queryverse/VegaLite.jl). The macro uses a syntax that is closely aligned with the JSON format of the original [Vega](https://vega.github.io/vega/) specification. It is very simple to take a Vega specification and "translate" it into a corresponding `@vgplot` macro call.

A typical [Vega](https://vega.github.io/vega/) JSON specification looks like this:

```json
{
  "width": 400,
  "height": 200,
  "padding": 5,

  "data": [
    {
      "name": "table",
      "values": [
        {"category": "A", "amount": 28},
        {"category": "B", "amount": 55},
        {"category": "C", "amount": 43},
        {"category": "D", "amount": 91},
        {"category": "E", "amount": 81},
        {"category": "F", "amount": 53},
        {"category": "G", "amount": 19},
        {"category": "H", "amount": 87}
      ]
    }
  ],

  "signals": [
    {
      "name": "tooltip",
      "value": {},
      "on": [
        {"events": "rect:mouseover", "update": "datum"},
        {"events": "rect:mouseout",  "update": "{}"}
      ]
    }
  ],

  "scales": [
    {
      "name": "xscale",
      "type": "band",
      "domain": {"data": "table", "field": "category"},
      "range": "width",
      "padding": 0.05,
      "round": true
    },
    {
      "name": "yscale",
      "domain": {"data": "table", "field": "amount"},
      "nice": true,
      "range": "height"
    }
  ],

  "axes": [
    { "orient": "bottom", "scale": "xscale" },
    { "orient": "left", "scale": "yscale" }
  ],

  "marks": [
    {
      "type": "rect",
      "from": {"data":"table"},
      "encode": {
        "enter": {
          "x": {"scale": "xscale", "field": "category"},
          "width": {"scale": "xscale", "band": 1},
          "y": {"scale": "yscale", "field": "amount"},
          "y2": {"scale": "yscale", "value": 0}
        },
        "update": {
          "fill": {"value": "steelblue"}
        },
        "hover": {
          "fill": {"value": "red"}
        }
      }
    },
    {
      "type": "text",
      "encode": {
        "enter": {
          "align": {"value": "center"},
          "baseline": {"value": "bottom"},
          "fill": {"value": "#333"}
        },
        "update": {
          "x": {"scale": "xscale", "signal": "tooltip.category", "band": 0.5},
          "y": {"scale": "yscale", "signal": "tooltip.amount", "offset": -2},
          "text": {"signal": "tooltip.amount"},
          "fillOpacity": [
            {"test": "datum === tooltip", "value": 0},
            {"value": 1}
          ]
        }
      }
    }
  ]
}
```

This can be directly translated into the following `@vgplot` macro call:

```julia
using VegaLite

@vgplot(
    height=200,
    padding=5,
    marks=[
        {
            encode={
                update={
                    fill={
                        value="steelblue"
                    }
                },
                hover={
                    fill={
                        value="red"
                    }
                },
                enter={
                    x={
                        field="category",
                        scale="xscale"
                    },
                    y2={
                        value=0,
                        scale="yscale"
                    },
                    width={
                        scale="xscale",
                        band=1
                    },
                    y={
                        field="amount",
                        scale="yscale"
                    }
                }
            },
            from={
                data="table"
            },
            type="rect"
        },
        {
            encode={
                update={
                    x={
                        signal="tooltip.category",
                        scale="xscale",
                        band=0.5
                    },
                    fillOpacity=[
                        {
                            test="datum === tooltip",
                            value=0
                        },
                        {
                            value=1
                        }
                    ],
                    text={
                        signal="tooltip.amount"
                    },
                    y={
                        offset=-2,
                        signal="tooltip.amount",
                        scale="yscale"
                    }
                },
                enter={
                    fill={
                        value="#333"
                    },
                    baseline={
                        value="bottom"
                    },
                    align={
                        value="center"
                    }
                }
            },
            type="text"
        }
    ],
    axes=[
        {
            scale="xscale",
            orient="bottom"
        },
        {
            scale="yscale",
            orient="left"
        }
    ],
    data=[
        {
            name="table",
            values=[
                {
                    amount=28,
                    category="A"
                },
                {
                    amount=55,
                    category="B"
                },
                {
                    amount=43,
                    category="C"
                },
                {
                    amount=91,
                    category="D"
                },
                {
                    amount=81,
                    category="E"
                },
                {
                    amount=53,
                    category="F"
                },
                {
                    amount=19,
                    category="G"
                },
                {
                    amount=87,
                    category="H"
                }
            ]
        }
    ],
    scales=[
        {
            name="xscale",
            padding=0.05,
            range="width",
            domain={
                data="table",
                field="category"
            },
            type="band",
            round=true
        },
        {
            name="yscale",
            nice=true,
            range="height",
            domain={
                data="table",
                field="amount"
            }
        }
    ],
    width=400,
    signals=[
        {
            name="tooltip",
            on=[
                {
                    events="rect:mouseover",
                    update="datum"
                },
                {
                    events="rect:mouseout",
                    update="{}"
                }
            ],
            value={

            }
        }
    ]
)
```

The main difference between JSON and the `@vgplot` macro is that keys are not surrounded by quotation marks in the macro, and key-value pairs are separate by a `=` (instead of a `:`).

## The `vg` string macro

Similar to the `vl` string macro, the `vg` string macro takes the Vega spec as a JSON string and returns and renders a `VGSpec`.

```julia
using VegaLite

spec = vg"""
  {
  "width": 400,
  "height": 200,
  "padding": 5,

  "data": [
    {
      "name": "table",
      "values": [
        {"category": "A", "amount": 28},
        {"category": "B", "amount": 55},
        {"category": "C", "amount": 43},
        {"category": "D", "amount": 91},
        {"category": "E", "amount": 81},
        {"category": "F", "amount": 53},
        {"category": "G", "amount": 19},
        {"category": "H", "amount": 87}
      ]
    }
  ],

  "signals": [
    {
      "name": "tooltip",
      "value": {},
      "on": [
        {"events": "rect:mouseover", "update": "datum"},
        {"events": "rect:mouseout",  "update": "{}"}
      ]
    }
  ],

  "scales": [
    {
      "name": "xscale",
      "type": "band",
      "domain": {"data": "table", "field": "category"},
      "range": "width",
      "padding": 0.05,
      "round": true
    },
    {
      "name": "yscale",
      "domain": {"data": "table", "field": "amount"},
      "nice": true,
      "range": "height"
    }
  ],

  "axes": [
    { "orient": "bottom", "scale": "xscale" },
    { "orient": "left", "scale": "yscale" }
  ],

  "marks": [
    {
      "type": "rect",
      "from": {"data":"table"},
      "encode": {
        "enter": {
          "x": {"scale": "xscale", "field": "category"},
          "width": {"scale": "xscale", "band": 1},
          "y": {"scale": "yscale", "field": "amount"},
          "y2": {"scale": "yscale", "value": 0}
        },
        "update": {
          "fill": {"value": "steelblue"}
        },
        "hover": {
          "fill": {"value": "red"}
        }
      }
    },
    {
      "type": "text",
      "encode": {
        "enter": {
          "align": {"value": "center"},
          "baseline": {"value": "bottom"},
          "fill": {"value": "#333"}
        },
        "update": {
          "x": {"scale": "xscale", "signal": "tooltip.category", "band": 0.5},
          "y": {"scale": "yscale", "signal": "tooltip.amount", "offset": -2},
          "text": {"signal": "tooltip.amount"},
          "fillOpacity": [
            {"test": "datum === tooltip", "value": 0},
            {"value": 1}
          ]
        }
      }
    }
  ]
  }
"""
```

## Data

The easiest way to pass data into a Vega spec is to use the `@vgplot` macro, and assign the data to the `data` element. There are various options:

1. You can pass a `Pair` as an element in the `data` vector, where the key is the name of the data source and the value any iterable table.
2. You can also assign any iterable table to the `value` field inside a composite object in the `data` vector.

The first option looks like this:

```julia
...,
data = [:my_datasource_name=>mydataframe],
...
```

The second option looks like this:
```julia
...,
data = [
  {
    name=:my_datasource,
    values=mydataframe
  }
],
...
```

A full example of a Vega plot that uses the first option looks like this:

```julia
using VegaLite, VegaDatasets

@vgplot(
    height=200,
    width=200,
    padding=5,    
    data=[:source=>dataset("cars")],    
    marks=[{
        name="marks",
        encode={
            update={
                shape={value="circle"},
                x={field="Horsepower", scale="x"},
                y={field="Miles_per_Gallon", scale="y"}
            }
        },
        from={data="source"},
        type="symbol"
    }],
    axes=[
        {
            domain=false,
            tickCount=5,
            grid=true,
            title="Horsepower",
            scale="x",
            orient="bottom"
        },
        {
            domain=false,
            grid=true,
            titlePadding=5,
            title="Miles_per_Gallon",
            scale="y",
            orient="left"
        }
    ],    
    scales=[
        {
            name="x",
            nice=true,
            zero=true,
            range="width",
            domain={data="source",field="Horsepower"},
            type="linear",
            round=true
        },
        {
            name="y",
            nice=true,
            zero=true,
            range="height",
            domain={data="source",field="Miles_per_Gallon"},
            type="linear",
            round=true
        }
    ]
)
```

## Loading and saving Vega specifications

The `load` and `save` functions can be used to load and save vega specifications to and from disc. The following example loads a vega specification from a file named `myfigure.vega`:

```julia
using VegaLite

spec = load("myfigure.vega")
```

To save a `VGSpec` to a file on disc, use the `save` function:

```julia
using VegaLite

spec = ... # Aquire a spec from somewhere

spec |> save("myfigure.vega")
```
