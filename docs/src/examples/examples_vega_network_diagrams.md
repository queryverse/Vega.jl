# Network Diagrams

## Edge Bundling

```@example
using Vega, VegaDatasets

@vgplot(
    height=720,
    padding=5,
    marks=[
        {
            encode={
                update={
                    align={
                        signal="datum.leftside ? 'right' : 'left'"
                    },
                    fontWeight=[
                        {
                            test="indata('selected', 'source', datum.id)",
                            value="bold"
                        },
                        {
                            test="indata('selected', 'target', datum.id)",
                            value="bold"
                        },
                        {
                            value=nothing
                        }
                    ],
                    x={
                        field="x"
                    },
                    dx={
                        signal="textOffset * (datum.leftside ? -1 : 1)"
                    },
                    fontSize={
                        signal="textSize"
                    },
                    angle={
                        signal="datum.leftside ? datum.angle - 180 : datum.angle"
                    },
                    fill=[
                        {
                            test="datum.id === active",
                            value="black"
                        },
                        {
                            test="indata('selected', 'source', datum.id)",
                            signal="colorIn"
                        },
                        {
                            test="indata('selected', 'target', datum.id)",
                            signal="colorOut"
                        },
                        {
                            value="black"
                        }
                    ],
                    y={
                        field="y"
                    }
                },
                enter={
                    text={
                        field="name"
                    },
                    baseline={
                        value="middle"
                    }
                }
            },
            from={
                data="leaves"
            },
            type="text"
        },
        {
            marks=[
                {
                    encode={
                        update={
                            tension={
                                signal="tension"
                            },
                            stroke=[
                                {
                                    test="parent.source === active",
                                    signal="colorOut"
                                },
                                {
                                    test="parent.target === active",
                                    signal="colorIn"
                                },
                                {
                                    value="steelblue"
                                }
                            ],
                            x={
                                field="x"
                            },
                            strokeOpacity=[
                                {
                                    test="parent.source === active || parent.target === active",
                                    value=1
                                },
                                {
                                    value=0.2
                                }
                            ],
                            y={
                                field="y"
                            }
                        },
                        enter={
                            interpolate={
                                value="bundle"
                            },
                            strokeWidth={
                                value=1.5
                            }
                        }
                    },
                    interactive=false,
                    from={
                        data="path"
                    },
                    type="line"
                }
            ],
            from={
                facet={
                    name="path",
                    data="dependencies",
                    field="treepath"
                }
            },
            type="group"
        }
    ],
    data=[
        {
            name="tree",
            values=dataset("flare"),
            transform=[
                {
                    key="id",
                    parentKey="parent",
                    type="stratify"
                },
                {
                    method={
                        signal="layout"
                    },
                    as=[
                        "alpha",
                        "beta",
                        "depth",
                        "children"
                    ],
                    size=[
                        1,
                        1
                    ],
                    type="tree"
                },
                {
                    as="angle",
                    expr="(rotate + extent * datum.alpha + 270) % 360",
                    type="formula"
                },
                {
                    as="leftside",
                    expr="inrange(datum.angle, [90, 270])",
                    type="formula"
                },
                {
                    as="x",
                    expr="originX + radius * datum.beta * cos(PI * datum.angle / 180)",
                    type="formula"
                },
                {
                    as="y",
                    expr="originY + radius * datum.beta * sin(PI * datum.angle / 180)",
                    type="formula"
                }
            ]
        },
        {
            name="leaves",
            source="tree",
            transform=[
                {
                    expr="!datum.children",
                    type="filter"
                }
            ]
        },
        {
            name="dependencies",
            values=dataset("flare-dependencies"),
            transform=[
                {
                    initonly=true,
                    as="treepath",
                    expr="treePath('tree', datum.source, datum.target)",
                    type="formula"
                }
            ]
        },
        {
            name="selected",
            source="dependencies",
            transform=[
                {
                    expr="datum.source === active || datum.target === active",
                    type="filter"
                }
            ]
        }
    ],
    scales=[
        {
            name="color",
            range=[
                {
                    signal="colorIn"
                },
                {
                    signal="colorOut"
                }
            ],
            domain=[
                "depends on",
                "imported by"
            ],
            type="ordinal"
        }
    ],
    width=720,
    autosize="none",
    signals=[
        {
            name="tension",
            bind={
                step=0.01,
                max=1,
                min=0,
                input="range"
            },
            value=0.85
        },
        {
            name="radius",
            bind={
                max=400,
                min=20,
                input="range"
            },
            value=280
        },
        {
            name="extent",
            bind={
                step=1,
                max=360,
                min=0,
                input="range"
            },
            value=360
        },
        {
            name="rotate",
            bind={
                step=1,
                max=360,
                min=0,
                input="range"
            },
            value=0
        },
        {
            name="textSize",
            bind={
                step=1,
                max=20,
                min=2,
                input="range"
            },
            value=8
        },
        {
            name="textOffset",
            bind={
                step=1,
                max=10,
                min=0,
                input="range"
            },
            value=2
        },
        {
            name="layout",
            bind={
                options=[
                    "tidy",
                    "cluster"
                ],
                input="radio"
            },
            value="cluster"
        },
        {
            name="colorIn",
            value="firebrick"
        },
        {
            name="colorOut",
            value="forestgreen"
        },
        {
            name="originX",
            update="width / 2"
        },
        {
            name="originY",
            update="height / 2"
        },
        {
            name="active",
            on=[
                {
                    events="text:mouseover",
                    update="datum.id"
                },
                {
                    events="mouseover[!event.item]",
                    update="null"
                }
            ],
            value=nothing
        }
    ],
    legends=[
        {
            stroke="color",
            title="Dependencies",
            symbolType="stroke",
            orient="bottom-right"
        }
    ]
)
```

## Force Directed Layout

TODO We need to figure out how we can handle this type of data loading first.

## Reorderable Matrix

TODO We need to figure out how we can handle this type of data loading first.

## Arc Diagram

TODO We need to figure out how we can handle this type of data loading first.

## Airport Connections

TODO We need to figure out how we can handle this type of data loading first.
