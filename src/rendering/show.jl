
function Base.show(io::IO, m::MIME"text/plain", v::VLSpec)
    print(io, summary(v))
end

function Base.show(io::IO, m::MIME"text/plain", v::VGSpec)
    print(io, summary(v))
end

function convert_to_svg(v::VLSpec{:plot})
    data = JSON.json(v.params)
    script_path = joinpath(@__DIR__, "compilesvg.js")
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

function convert_to_svg(v::VGSpec)
    data = JSON.json(v.params)
    script_path = joinpath(@__DIR__, "compilevg2svg.js")
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

Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vegalite.v2+json")}) = true
Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vega.v3+json")}) = true

function Base.show(io::IO, m::MIME"application/vnd.vegalite.v2+json", v::VLSpec{:plot})
     print(io, JSON.json(v.params))
end

function Base.show(io::IO, m::MIME"application/vnd.vega.v3+json", v::VGSpec)
    print(io, JSON.json(v.params))
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VLSpec{:plot})
   svgHeader = """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
"""

    print(io, svgHeader)
    print(io, convert_to_svg(v))
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VGSpec)
    svgHeader = """
 <?xml version="1.0" encoding="utf-8"?>
 <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
 """
 
     print(io, svgHeader)
     print(io, convert_to_svg(v))
 end

function Base.show(io::IO, m::MIME"application/pdf", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoPDFSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

function Base.show(io::IO, m::MIME"application/pdf", v::VGSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoPDFSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

function Base.show(io::IO, m::MIME"application/eps", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

function Base.show(io::IO, m::MIME"application/eps", v::VGSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.finish(cs)
end

# function Base.show(io::IO, m::MIME"application/postscript", v::VLSpec{:plot})
#     svgstring = convert_to_svg(v)

#     r = Rsvg.handle_new_from_data(svgstring)
#     d = Rsvg.handle_get_dimensions(r)

#     cs = Cairo.CairoPSSurface(io, d.width,d.height)
#     c = Cairo.CairoContext(cs)
#     Rsvg.handle_render_cairo(c,r)
#     Cairo.finish(cs)
# end

function Base.show(io::IO, m::MIME"image/png", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.write_to_png(cs,io)
end

function Base.show(io::IO, m::MIME"image/png", v::VGSpec)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.write_to_png(cs,io)
end
