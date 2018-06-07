function fileio_load(f::FileIO.File{FileIO.format"vegalite"})
    return loadspec(f.filename)
end

function fileio_save(file::FileIO.File{FileIO.format"vegalite"}, data::VLSpec{:plot}; include_data=true)
    savespec(file.filename, data, include_data=include_data)
end
