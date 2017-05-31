function savefig(filename::AbstractString, v::VegaLiteVis)
    file_ext = lowercase(splitext(filename)[2])
    if file_ext == ".svg"
        mime = "image/svg+xml"
    elseif file_ext == ".pdf"
        mime = "application/pdf"
    elseif file_ext == ".png"
        mime = "image/png"
    else
        throw(ArgumentError("Unknown file type."))
    end

    open(filename, "w") do f
        show(f, mime, v)
    end    
end
