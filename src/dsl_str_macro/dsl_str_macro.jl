macro vl_str(content)
    return VLSpec(JSON.parse(content))
end

macro vg_str(content)
    return VGSpec(JSON.parse(content))
end
