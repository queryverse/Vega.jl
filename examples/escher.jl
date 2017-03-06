# Adapted from Escher/examples/plotting.jl

using VegaLite
using Distributions

plot_beta(α, β) = x -> pdf(Beta(α, β), x)

main(window) = begin
    push!(window.assets, "widgets")
    push!(window.assets, ("VegaLite", "vega-lite"))  # needed for VegaLite

    αᵗ = Signal(1.0)
    βᵗ = Signal(1.0)

    xs = linspace(0,25,100)
    ys = sin(xs)

    vbox(md"## Static Plot",

        data_values(x=xs, y=ys) +
          mark_line() +
          encoding_x_quant(:x) +
          encoding_y_quant(:y) +
          config_cell(width=500, height=100) ,

        md"## Dynamic plot",
        hbox("Alpha: " |>
            width(4em), slider(1:100) >>> αᵗ) |>
            packacross(center),
        hbox("Beta: "  |>
            width(4em), slider(1:100) >>> βᵗ) |>
            packacross(center),
        map(αᵗ, βᵗ) do α, β
          xs = linspace(0,1.,100)
          ys = map(plot_beta(α, β), xs)

          data_values(x=xs, y=ys) +
            mark_line() +
            encoding_x_quant(:x) +
            encoding_y_quant(:y) +
            config_cell(width=500, height=200)

        end
    ) |> Escher.pad(2em)
end
