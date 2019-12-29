"""
    printrepr(io, v::AbstractVegaSpec)

Print representation of a Vega spec `v` parsable by Julia.  It accepts
the same keyword arguments as [`savespec`](@ref).
"""
function printrepr(io::IO, v::Union{VLSpec, VGSpec}; kwargs...)
    println(io, v isa VGSpec ? "vg" : "vl", "\"\"\"")
    savespec(io, v; include_data=true, indent=4, kwargs...)
    print(io, "\"\"\"")
end

function print_datavaluesnode_as_julia(io, it, col_names)
    print(io, "{values=[")

    for (row_index, row) in enumerate(it)
        row_index==1 || print(io, ",")
        print(io, "{")

        for (col_index, col_value) in enumerate(row)
            col_index==1 || print(io, ",")
            print(io, col_names[col_index])
            print(io, "=")
            print(io, col_value isa DataValue ? get(col_value, nothing) : col_value)
        end

        print(io, "}")
    end

    print(io, "]}")
end

function print_vspec_as_julia(io::IO, d::DataValuesNode, indent)
    col_names = collect(keys(d.columns))
    it = TableTraitsUtils.create_tableiterator(collect(values(d.columns)), col_names)

    print_datavaluesnode_as_julia(io, it, col_names)
end

function print_vspec_as_julia(io::IO, vect::AbstractVector, indent)
    for (i,v) in enumerate(vect)
        i>1 && print(io, ",\n")
        if v isa AbstractDict
            print(io, " "^indent, "{\n")
            print_vspec_as_julia(io, v, indent+4)
            print(io, "\n", " "^indent, "}")
        elseif v isa AbstractVector
            print(io, "[\n")
            print_vspec_as_julia(io, v, indent+4)
            print(io, "\n", " "^indent, "]")
        elseif v isa DataValuesNode
            print_vspec_as_julia(io, v, indent)
        else
            print(io, v)
        end
    end
end

function print_vspec_as_julia(io::IO, dict::AbstractDict, indent)
    for (i,(k,v)) in enumerate(dict)
        i>1 && print(io, ",\n")
        print(io, " "^indent, k)
        print(io, "=")
        if v isa AbstractDict
            print(io, "{")
            println(io)
            print_vspec_as_julia(io, v, indent+4)
            print(io, "\n", " "^indent, "}")
        elseif v isa AbstractVector
            print(io, "[\n")
            print_vspec_as_julia(io, v, indent+4)
            print(io, "\n", " "^indent, "]")
        elseif v isa AbstractString || v isa Symbol
            print(io, "\"")
            print(io, string(v))
            print(io, "\"")
        elseif v isa DataValuesNode
            print_vspec_as_julia(io, v, indent)
        else
            print(io, v)
        end
    end
end

function printrepr2(io::IO, v::AbstractVegaSpec)
    println(io, v isa VGSpec ? "@vgplot(" : "@vlplot(")
    print_vspec_as_julia(io, getparams(v), 4)    
    println(io, "\n)")
end

function printrepr2(v::AbstractVegaSpec)
    printrepr2(stdout, v)
end

function Base.show(io::IO, m::MIME"text/plain", v::AbstractVegaSpec)
    if !get(io, :compact, true) && v isa Union{VLSpec, VGSpec}
        printrepr2(io, v)
    else
        print(io, summary(v))
    end
    return
end

function convert_vl_to_vg(v::VLSpec)
    vl2vg_script_path = joinpath(vegaliate_app_path, "vl2vg.js")
    p = open(Cmd(`$(nodejs_cmd()) $vl2vg_script_path`, dir=vegaliate_app_path), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.exitcode!=0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

function convert_vl_to_x(v::VLSpec, second_script)
    vl2vg_script_path = joinpath(vegaliate_app_path, "vl2vg.js")
    full_second_script_path = joinpath(vegaliate_app_path, "node_modules", "vega-cli", "bin", second_script)
    p = open(pipeline(Cmd(`$(nodejs_cmd()) $vl2vg_script_path`, dir=vegaliate_app_path), Cmd(`$(nodejs_cmd()) $full_second_script_path`, dir=vegaliate_app_path)), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.processes[1].exitcode!=0 || p.processes[2].exitcode!=0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

function convert_vg_to_x(v::VGSpec, script)
    full_script_path = joinpath(vegaliate_app_path, "node_modules", "vega-cli", "bin", script)
    p = open(Cmd(`$(nodejs_cmd()) $full_script_path`, dir=vegaliate_app_path), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.exitcode!=0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

function convert_vl_to_svg(v::VLSpec)
    vl2vg_script_path = joinpath(vegaliate_app_path, "vl2vg.js")
    vg2svg_script_path = joinpath(vegaliate_app_path, "vg2svg.js")
    p = open(pipeline(Cmd(`$(nodejs_cmd()) $vl2vg_script_path`, dir=vegaliate_app_path), Cmd(`$(nodejs_cmd()) $vg2svg_script_path`, dir=vegaliate_app_path)), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.processes[1].exitcode!=0 || p.processes[2].exitcode!=0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

function convert_vg_to_svg(v::VGSpec)
    vg2svg_script_path = joinpath(vegaliate_app_path, "vg2svg.js")
    p = open(Cmd(`$(nodejs_cmd()) $vg2svg_script_path`, dir=vegaliate_app_path), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.exitcode!=0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vegalite.v4+json")}) = true
Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vega.v5+json")}) = true

function Base.show(io::IO, m::MIME"application/vnd.vegalite.v4+json", v::VLSpec)
    our_json_print(io, v)
end

function Base.show(io::IO, m::MIME"application/vnd.vega.v5+json", v::VGSpec)
    our_json_print(io, v)
end

function Base.show(io::IO, m::MIME"application/vnd.vega.v5+json", v::VLSpec)

    print(io, convert_vl_to_vg(v))
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VLSpec)
    print(io, convert_vl_to_svg(v))
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VGSpec)
    print(io, convert_vg_to_svg(v))
end

function Base.show(io::IO, m::MIME"application/pdf", v::VLSpec)
    if vegaliate_app_includes_canvas
        print(io, convert_vl_to_x(v, "vg2pdf"))
    else
        svgstring = convert_vl_to_svg(v)

        r = Rsvg.handle_new_from_data(svgstring)
        d = Rsvg.handle_get_dimensions(r)

        cs = Cairo.CairoPDFSurface(io, d.width,d.height)
        try
            c = Cairo.CairoContext(cs)
            Rsvg.handle_render_cairo(c,r)
        finally
            Cairo.finish(cs)
        end
    end
end

function Base.show(io::IO, m::MIME"application/pdf", v::VGSpec)
    if vegaliate_app_includes_canvas
        print(io, convert_vg_to_x(v, "vg2pdf"))
    else
        svgstring = convert_vg_to_svg(v)

        r = Rsvg.handle_new_from_data(svgstring)
        d = Rsvg.handle_get_dimensions(r)

        cs = Cairo.CairoPDFSurface(io, d.width,d.height)
        try
            c = Cairo.CairoContext(cs)
            Rsvg.handle_render_cairo(c,r)
        finally
            Cairo.finish(cs)
        end
    end
end

function Base.show(io::IO, m::MIME"application/eps", v::VLSpec)
    svgstring = convert_vl_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    try
        c = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(c,r)
    finally
        Cairo.finish(cs)
    end
end

function Base.show(io::IO, m::MIME"application/eps", v::VGSpec)
    svgstring = convert_vg_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    try
        c = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(c,r)
    finally
        Cairo.finish(cs)
    end
end

function Base.show(io::IO, m::MIME"image/png", v::VLSpec)
    if vegaliate_app_includes_canvas
        print(io, convert_vl_to_x(v, "vg2png"))
    else
        svgstring = convert_vl_to_svg(v)

        r = Rsvg.handle_new_from_data(svgstring)
        d = Rsvg.handle_get_dimensions(r)

        cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
        c = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(c,r)
        Cairo.write_to_png(cs,io)
    end
end

function Base.show(io::IO, m::MIME"image/png", v::VGSpec)
    if vegaliate_app_includes_canvas
        print(io, convert_vg_to_x(v, "vg2png"))
    else
        svgstring = convert_vg_to_svg(v)

        r = Rsvg.handle_new_from_data(svgstring)
        d = Rsvg.handle_get_dimensions(r)

        cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
        c = Cairo.CairoContext(cs)
        Rsvg.handle_render_cairo(c,r)
        Cairo.write_to_png(cs,io)
    end
end
