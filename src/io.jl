function savefig(filename::AbstractString, mime::AbstractString, v::VegaLiteVis)
    open(filename, "w") do f
        show(f, mime, v)
    end        
end

"""
    savefig(filename::AbstractString, v::VegaLiteVis)

Save the plot ``v`` as a file with name ``filename``. The file format
will be picked based on the extension of the filename.
"""
function savefig(filename::AbstractString, v::VegaLiteVis)
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
    svg(filename::AbstractString, v::VegaLiteVis)

Save the plot ``v``` as a svg file with name ``filname``.
"""
function svg(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "image/svg+xml", v)
end

"""
    pdf(filename::AbstractString, v::VegaLiteVis)

Save the plot ``v``` as a pdf file with name ``filname``.
"""
function pdf(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "application/pdf", v)
end

"""
    png(filename::AbstractString, v::VegaLiteVis)

Save the plot ``v``` as a png file with name ``filname``.
"""
function png(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "image/png", v)
end

"""
    eps(filename::AbstractString, v::VegaLiteVis)

Save the plot ``v``` as a eps file with name ``filname``.
"""
function eps(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "application/eps", v)
end
