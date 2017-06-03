function savefig(filename::AbstractString, mime::AbstractString, v::VegaLiteVis)
    open(filename, "w") do f
        show(f, mime, v)
    end        
end

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

function svg(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "image/svg+xml", v)
end

function pdf(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "application/pdf", v)
end

function png(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "image/png", v)
end

function eps(filename::AbstractString, v::VegaLiteVis)
    savefig(filename, "application/eps", v)
end
