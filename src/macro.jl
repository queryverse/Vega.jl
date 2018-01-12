macro vl_str(content)
    return VLSpec{:plot}(JSON.parse(content))
end
