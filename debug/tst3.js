d3 = require('D:/frtestar/.julia/v0.4/VegaLite/assets/bower_components/d3/d3.min.js');
vg = require('D:/frtestar/.julia/v0.4/VegaLite/assets/bower_components/vega/vega.js');
ve = require('D:/frtestar/.julia/v0.4/VegaLite/assets/bower_components/vega-embed/vega-embed.js');
vl = require('D:/frtestar/.julia/v0.4/VegaLite/assets/bower_components/vega-lite/vega-lite.js');

var spec = {
    "width": 400,
    "height": 400,
    "data": [
      {
        "name": "table",
        "values": [12, 23, 47, 6, 52, 19],
        "transform": [{"type": "pie", "field": "data"}]
      }
    ],
    "scales": [
      {
        "name": "r",
        "type": "sqrt",
        "domain": {"data": "table", "field": "data"},
        "range": [20, 100]
      }
    ],
    "marks": [
      {
        "type": "arc",
        "from": {"data": "table"},
        "properties": {
          "enter": {
            "x": {"field": {"group": "width"}, "mult": 0.5},
            "y": {"field": {"group": "height"}, "mult": 0.5},
            "startAngle": {"field": "layout_start"},
            "endAngle": {"field": "layout_end"},
            "innerRadius": {"value": 20},
            "outerRadius": {"scale": "r", "field": "data"},
            "stroke": {"value": "#fff"}
          },
          "update": {
            "fill": {"value": "#ccc"}
          },
          "hover": {
            "fill": {"value": "pink"}
          }
        }
      },
      {
        "type": "text",
        "from": {"data": "table"},
        "properties": {
          "enter": {
            "x": {"field": {"group": "width"}, "mult": 0.5},
            "y": {"field": {"group": "height"}, "mult": 0.5},
            "radius": {"scale": "r", "field": "data", "offset": 8},
            "theta": {"field": "layout_mid"},
            "fill": {"value": "#000"},
            "align": {"value": "center"},
            "baseline": {"value": "middle"},
            "text": {"field": "data"}
          }
        }
      }
    ]
  } ;

  // console.log(spec)
  // console.log(vg.config)


vg.parse.spec(spec, function(err, chart) {
  if (err) { throw err; }

  // global['canvas'] = {"prototype" : ''};

  var view = chart({ renderer: 'svg' })
    .update();

  //writeSVG(view.svg(), outputFile);
});

vg.parse.spec(spec, function(chart) {
  // console.log(chart)

  var view = chart({ renderer: 'svg' }).update() ;
  // var view = chart({ renderer: 'canvas' }).update() ;

  // var view = chart({ renderer: "svg" }).update();
  // var svg = view.svg();
  // console.log(svg);
} ) ;
