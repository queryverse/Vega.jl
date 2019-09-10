################################################################################
#  Save to file functions
################################################################################

function savefig(filename::AbstractString, mime::AbstractString, v::VLSpec{:plot})
    open(filename, "w") do f
        show(f, mime, v)
    end
end


"""
    savefig(filename::AbstractString, v::VLSpec{:plot})
Save the plot ``v`` as a file with name ``filename``. The file format
will be picked based on the extension of the filename.
"""
function savefig(filename::AbstractString, v::VLSpec{:plot})
    file_ext = lowercase(splitext(filename)[2])
    if file_ext == ".svg"
        mime = "image/svg+xml"
    elseif file_ext == ".pdf"
        mime = "application/pdf"
    elseif file_ext == ".png"
        mime = "image/png"
    elseif file_ext == ".eps"
        mime = "application/eps"
    # elseif file_ext == ".ps"
    #     mime = "application/postscript"
    else
        throw(ArgumentError("Unknown file type."))
    end

    savefig(filename, mime, v)
end

"""
    loadspec(filename::AbstractString)
    loadspec(io::IO)

Load a vega-lite specification from a file with name `filename`. An `IO`
object can also be passed. Returns a `VLSpec` object.
"""
loadspec(filename::AbstractString) = open(loadspec, filename)
loadspec(io::IO) = VLSpec{:plot}(JSON.parse(io))

"""
    loadvgspec(filename::AbstractString)

Load a vega specification from a file with name `filename`. Returns
a `VGSpec` object.
"""
loadvgspec(filename::AbstractString) = open(loadvgspec, filename)
loadvgspec(io::IO) = VGSpec(JSON.parse(io))

"""
    savespec(filename::AbstractString, v::VLSpec{:plot})
    savespec(io::IO, v::VLSpec{:plot})

Save the plot `v` as a vega-lite specification file with the name `filename`.
An `IO` object can also be passed.

# Keyword Arguments
- `include_data::Bool`: The `include_data` argument controls
  whether the data should be included in the saved specification file.
- `indent::Union{Nothing,Integer}`: Pretty-print JSON output with given
  indentation if `indent` is an integer.
"""
function savespec(io::IO, v::AbstractVegaSpec; include_data=false, indent=nothing)
    output_dict = copy(v.params)
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

"""
    svg(filename::AbstractString, v::VLSpec{:plot})
Save the plot ``v`` as a svg file with name ``filename``.
"""
function svg(filename::AbstractString, v::VLSpec{:plot})
    savefig(filename, "image/svg+xml", v)
end

"""
    pdf(filename::AbstractString, v::VLSpec{:plot})
Save the plot ``v`` as a pdf file with name ``filename``.
"""
function pdf(filename::AbstractString, v::VLSpec{:plot})
    savefig(filename, "application/pdf", v)
end

"""
    png(filename::AbstractString, v::VLSpec{:plot})
Save the plot ``v`` as a png file with name ``filename``.
"""
function png(filename::AbstractString, v::VLSpec{:plot})
    savefig(filename, "image/png", v)
end

"""
    eps(filename::AbstractString, v::VLSpec{:plot})
Save the plot ``v`` as a eps file with name ``filename``.
"""
function eps(filename::AbstractString, v::VLSpec{:plot})
    savefig(filename, "application/eps", v)
end
