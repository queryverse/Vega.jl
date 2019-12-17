# Output

## Saving to a file

Use the `save` (reexported from VegaLite.jl) function from the [FileIO.jl](https://github.com/JuliaIO/FileIO.jl) package to save plots.

For example, to save a plot named `p`, you can use the following type of code:

```julia
p |> save("figure.png")
p |> save("figure.svg")
p |> save("figure.pdf")
p |> save("figure.eps")
p |> save("figure.vegalite")
```
