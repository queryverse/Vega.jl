################################################################################
#  Save to file functions
################################################################################

function savefig(filename::AbstractString, mime::AbstractString, v::VLSpec{:plot})
    open(filename, "w") do f
        show(f, mime, v)
    end
end


# PhantomJS alternative
# function tofile(path::String, plt::VLSpec{:plot}, format::String)
#   checkplot(v)
#
#   pio = IOBuffer()
#   writehtml_full(pio, JSON.json(v.params))
#
#   out = PhantomJS.renderhtml(seekstart(pio),
#                              clipToSelector=".marks",
#                              format=format)
# end


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

function loadspec(filename::AbstractString)
    s = readstring(filename)
    return VLSpec{:plot}(JSON.parse(s))
end

function savespec(filename::AbstractString, v::VLSpec{:plot}; include_data=false)
    output_dict = copy(v.params)
    if !include_data
        delete!(output_dict, "data")
    end
    open(filename, "w") do f
        JSON.print(f, output_dict)
    end
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
