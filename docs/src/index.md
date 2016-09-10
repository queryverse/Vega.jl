# VegaLite.jl Documentation

The *VegaLite.jl* julia package provides access to the Vega-Lite high-level visualization grammar from Julia.

`Vega-Lite` (http://vega.github.io/vega-lite/) is a simpler version of the Vega grammar allowing smaller and more expressive chart specifications. For a finer control over the produced graph you can turn to the Vega.jl package (https://github.com/johnmyleswhite/Vega.jl). Parts of the VegaLite package (rendering functions, IJulia integration) are based on Vega.jl (thanks by the way !).

All contributions, PR or issue, are welcome !

```@contents
```

## Installation

Install with `Pkg.add("VegaLite")`.

## Vega-Lite design principles

Vega-Lite is a javascript library that renders a plot described in by JSON structure ( a 'spec').

In a manner similar to R's ggplot2, a plot is specified by :
- linking data vectors to 'channels' (x axis, y axis, size, text, column, rows, etc.),
- indicating how the data vector should be interpreted  
  - quantitative for continuous values,
  - temporal for dates or times,
  - ordinal for ordered data,
  - nominal for unordered symbols.
- and finally what kind 'mark' should be plotted : bars, ticks, lines, ...

See http://vega.github.io/vega-lite/ for a full documentation and tutorials.

## Implementation in `VegaLite.jl`

You don't have to create the JSON spec file yourself, the package takes care of that. It is built instead incrementally by specialized functions that store the pieces in a type which evaluates to a JSON spec / an HTML file / etc.. depending on the active backend.
The specialized functions try to follow closely the Vega-Lite JSON format, e.g:
- The function `data_values()` creates the `{"data": {values: { ...} }}` part of the spec file,
- `encoding_x_quant(:var, ...)` creates the part `encoding": { "x": {"field": "var", "type": "quantitative"}`,
- etc.

### Example:

- Plotting a simple line chart:

```julia
using VegaLite

ts = sort(rand(10))
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

v = data_values(time=ts, res=ys) +    # add the data vectors & assign to symbols 'time' and 'res'
      mark_line() +                   # mark type = line
      encoding_x_quant(:time) +       # bind x dimension to :time, quantitative scale
      encoding_y_quant(:res)          # bind y dimension to :res, quantitative scale
```

![plot1](../examples/png/vega %281%29.png)

More examples are provided in the examples folder.


In addition to the plot spec building functions, two functions help providing control over the plot render:
- `svg(Bool)` : sets the drawing mode of the plots, SVG if `true`, canvas if `false`. Default = `true`
- `buttons(Bool)` : indicates if the plot should be accompanied with links 'Save as PNG', 'View source' and 'Open in Vega Editor'. Default = `true`.

Most functions are documented, with the full list of their properties listed and explained, e.g. type `? config_mark` to get the full list of properties of the `config_mark` function, etc.

## Supported backends

| Backend | Behaviour |
|---------|-----|
| standard REPL | a browser window will open upon evaluation |
| Atom/Juno | a browser window will open (same as REPL) *rendering into the Atom plotpane is not possible currently* |
| Escher | the plot is rendered in web age *(do not forget to issue a     `push!(window.assets, ("VegaLite", "vega-lite"))` to load the vegalite library)* |
| IJulia/Jupyter | the plot will appear below the code block  |
