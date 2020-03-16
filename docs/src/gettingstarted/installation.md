# Installation

To install [Vega.jl](https://github.com/queryverse/Vega.jl), run the following command in the Julia Pkg REPL-mode:

```julia
pkg> add Vega
```

## REPL frontends

If you create plots from the standard Julia REPL, they will show up in a browser window when displayed.

As an alternative you can install [ElectronDisplay.jl](https://github.com/queryverse/ElectronDisplay.jl) with `pkg> add ElectronDisplay`. Whenever you load that package with `using ElectronDisplay`, any plot you display will then show up in an [electron](https://electronjs.org/) based window instead of a browser window.

## Notebook frontends

[Vega.jl](https://github.com/queryverse/Vega.jl) works with [Jupyter Lab](https://github.com/jupyterlab/jupyterlab), [Jupyter Notebook](http://jupyter.org/) and [nteract](https://nteract.io/).

The first step to use any of these notebooks frontends is to install them. The second step is to install the general Julia integration by running the following Julia code:

```julia
pkg> add IJulia
```

At that point you should be able to use [Vega.jl](https://github.com/queryverse/Vega.jl) in notebooks that have a Julia kernel.

We recommend that you use either [Jupyter Lab](https://github.com/jupyterlab/jupyterlab) or [nteract](https://nteract.io/) for the best [Vega.jl](https://github.com/queryverse/Vega.jl) experience: you will get the full interactive experience of [Vega-Lite](https://github.com/vega/vega-lite) in those two frontends without any further installations. While you can display plots in the classic [Jupyter Notebook](http://jupyter.org/), you won't get interactive plots in that environment without further setup steps.

## VS Code and Juno/Atom

If you plot from within VS Code with the [Julia extension](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia) or [Juno/Atom](http://junolab.org/), plots will show up in a plot pane in those editors.

Plots in VS Code support all features of [Vega.jl](https://github.com/queryverse/Vega.jl), including all interactive features. The plot pane in Juno currently does not support the interactive features of [Vega.jl](https://github.com/queryverse/Vega.jl).

## Example Datasets

Many of the examples in the documentation use data from the [Vega Datasets](https://github.com/vega/vega-datasets) repository. You can access these datasets easily with the Julia package [VegaDatasets.jl](https://github.com/queryverse/VegaDatasets.jl). To install that package, run the following Julia code:

```julia
pkg> add VegaDatasets
```
