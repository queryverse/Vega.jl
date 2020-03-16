"""
    loadvgspec(filename::AbstractString)

Load a vega specification from a file with name `filename`. Returns
a `VGSpec` object.
"""
loadvgspec(filename::AbstractString) = open(loadvgspec, filename)
loadvgspec(io::IO) = VGSpec(JSON.parse(io))

"""
    savespec(filename::AbstractString, v::VLSpec)
    savespec(io::IO, v::VLSpec)

Save the plot `v` as a vega-lite specification file with the name `filename`.
An `IO` object can also be passed.

# Keyword Arguments
- `include_data::Bool`: The `include_data` argument controls
  whether the data should be included in the saved specification file.
- `indent::Union{Nothing,Integer}`: Pretty-print JSON output with given
  indentation if `indent` is an integer.
"""
function savespec(io::IO, v::AbstractVegaSpec; include_data=false, indent=nothing)
    output_dict = copy(getparams(v))
    if !include_data
        delete!(output_dict, "data")
    end
    if indent === nothing
        JSON.print(io, output_dict)
    else
        JSON.print(io, output_dict, indent)
    end
end

savespec(filename::AbstractString, v::AbstractVegaSpec; kwargs...) =
    open(filename, "w") do io
        savespec(io, v; kwargs...)
    end
