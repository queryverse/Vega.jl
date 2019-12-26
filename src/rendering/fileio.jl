function fileio_load(f::FileIO.File{FileIO.format"vegalite"})
    return loadspec(f.filename)
end

function fileio_load(stream::FileIO.Stream{FileIO.format"vegalite"})
    return loadspec(stream.io)
end

function fileio_save(file::FileIO.File{FileIO.format"vegalite"}, data::VLSpec; include_data=true, kwargs...)
    savespec(file.filename, data; include_data=include_data, kwargs...)
end

function fileio_save(stream::FileIO.Stream{FileIO.format"vegalite"}, data::VLSpec; include_data=true, kwargs...)
    savespec(stream.io, data; include_data=include_data, kwargs...)
end

function fileio_load(f::FileIO.File{FileIO.format"vega"})
    return loadvgspec(f.filename)
end

function fileio_load(stream::FileIO.Stream{FileIO.format"vega"})
    return loadvgspec(stream.io)
end

function fileio_save(file::FileIO.File{FileIO.format"vega"}, data::VGSpec; include_data=true, kwargs...)
    savespec(file.filename, data; include_data=include_data, kwargs...)
end

function fileio_save(stream::FileIO.Stream{FileIO.format"vega"}, data::VGSpec; include_data=true, kwargs...)
    savespec(stream.io, data; include_data=include_data, kwargs...)
end
