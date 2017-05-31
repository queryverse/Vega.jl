function convert_to_svg(v::VegaLiteVis)
    data = JSON.json(v.vis)
    script_path = joinpath(@__DIR__, "compilesvg.js")
    p_out, p_in, p = readandwrite(`$(nodejs_cmd()) $script_path`)
    write(p_in, data)
    flush(p_in)
    close(p_in)
    res = readstring(p_out)
    close(p_out)
    return res
end

function savefig_svg(filename::AbstractString, v::VegaLiteVis)
    svgHeader = """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
"""

    open(filename, "w") do f
        print(f, svgHeader)
        print(f, convert_to_svg(v))
    end
end

function savefig_pdf(filename::AbstractString, v::VegaLiteVis)
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoPDFSurface(filename, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    finish(cs)
end

function savefig_png(filename::AbstractString, v::VegaLiteVis)
    svgstring = convert_to_svg(v)
    
    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.write_to_png(cs,filename)
end
