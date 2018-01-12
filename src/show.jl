function convert_to_svg(v::VLSpec{:plot})
    data = JSON.json(v.params)
    script_path = joinpath(@__DIR__, "compilesvg.js")
    p_out, p_in, p = readandwrite(`$(nodejs_cmd()) $script_path`)
    write(p_in, data)
    flush(p_in)
    close(p_in)
    res = readstring(p_out)
    close(p_out)
    return res
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VLSpec{:plot})
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
    finish(cs)
end

function Base.show(io::IO, m::MIME"application/eps", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoEPSSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    finish(cs)
end

# function Base.show(io::IO, m::MIME"application/postscript", v::VLSpec{:plot})
#     svgstring = convert_to_svg(v)

#     r = Rsvg.handle_new_from_data(svgstring)
#     d = Rsvg.handle_get_dimensions(r)

#     cs = Cairo.CairoPSSurface(io, d.width,d.height)
#     c = Cairo.CairoContext(cs)
#     Rsvg.handle_render_cairo(c,r)
#     finish(cs)
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

@compat function Base.show(io::IO, m::MIME"juliavscode/html", plt::VLSpec{:plot})
    divid = "vg" * randstring(3)
    spec = JSON.json(plt.params)
    html = """
        <html>
        <head>
            <title>Vega-lite plot</title>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vega/3.0.8/vega.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vega-lite/2.0.3/vega-lite.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vega-embed/3.0.0-rc7/vega-embed.min.js"></script>
        </head>
        <body>
            <div id="$divid"></div>
        </body>

        <script type="text/javascript">
            var opt = {
                mode: "vega-lite",
                renderer: "canvas",
                actions: false
            }

            var spec = $spec

            vegaEmbed('#$divid', spec, opt);

        </script>
        </html>
    """
    print(io, html)
end
