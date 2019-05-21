"""
    printrepr(io, v::AbstractVegaSpec)

Print representation of a Vega spec `v` parsable by Julia.  It accepts
the same keyword arguments as [`savespec`](@ref).
"""
function printrepr(io::IO, v::Union{VLSpec{:plot}, VGSpec}; kwargs...)
    println(io, v isa VGSpec ? "vg" : "vl", "\"\"\"")
    savespec(io, v; include_data=true, indent=4, kwargs...)
    print(io, "\"\"\"")
end

function Base.show(io::IO, m::MIME"text/plain", v::AbstractVegaSpec)
    if !get(io, :compact, true) && v isa Union{VLSpec{:plot}, VGSpec}
        printrepr(io, v)
    else
        print(io, summary(v))
    end
    return
end

function convert_to_svg(v::AbstractVegaSpec, script_path::String)
    data = JSON.json(v.params)
    p = open(`$(nodejs_cmd()) $script_path`, "r+")
    writer = @async begin
        write(p, data)
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

function convert_to_svg(v::VLSpec{:plot})
    script_path = joinpath(@__DIR__, "compilesvg.js")
    return convert_to_svg(v, script_path)
end

function convert_to_svg(v::VGSpec)
    script_path = joinpath(@__DIR__, "compilevg2svg.js")
    return convert_to_svg(v, script_path)
end

Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vegalite.v2+json")}) = true
Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vega.v4+json")}) = true

function Base.show(io::IO, m::MIME"application/vnd.vegalite.v2+json", v::VLSpec{:plot})
     print(io, JSON.json(v.params))
end

function Base.show(io::IO, m::MIME"application/vnd.vega.v4+json", v::VGSpec)
    print(io, JSON.json(v.params))
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::AbstractVegaSpec)
   svgHeader = """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
"""

    print(io, svgHeader)
    print(io, convert_to_svg(v))
end

function Base.show(io::IO, m::MIME"application/pdf", v::AbstractVegaSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoPDFSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

function Base.show(io::IO, m::MIME"application/eps", v::AbstractVegaSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

function Base.show(io::IO, m::MIME"image/png", v::AbstractVegaSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.write_to_png(cs,io)
end
