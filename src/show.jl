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

@compat function Base.show(io::IO, m::MIME"image/svg+xml", v::VLSpec{:plot})
   svgHeader = """
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
"""

    print(io, svgHeader)
    print(io, convert_to_svg(v))
end

@compat function Base.show(io::IO, m::MIME"application/pdf", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoPDFSurface(io, d.width,d.height)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    finish(cs)
end

@compat function Base.show(io::IO, m::MIME"application/eps", v::VLSpec{:plot})
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

@compat function Base.show(io::IO, m::MIME"image/png", v::VLSpec{:plot})
    svgstring = convert_to_svg(v)

    r = Rsvg.handle_new_from_data(svgstring)
    d = Rsvg.handle_get_dimensions(r)

    cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
    c = Cairo.CairoContext(cs)
    Rsvg.handle_render_cairo(c,r)
    Cairo.write_to_png(cs,io)
end

@compat function Base.show(io::IO, m::MIME"juliavscode/html", plt::VLSpec{:plot})
    schema = plt.params
    schema["\$schema"] = "https://vega.github.io/schema/vega-lite/v2.0.json"
    html = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Embedding Vega-Lite</title>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/vega/3.0.7/vega.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/vega-lite/2.0.1/vega-lite.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/vega-embed/3.0.0-rc7/vega-embed.js"></script>
    </head>
    <body>

      <div id="vis"></div>

      <script type="text/javascript">
        var yourVlSpec = $(JSON.json(schema))
        vegaEmbed("#vis", yourVlSpec);
      </script>
    </body>
    </html>
    """
    info(html)
    print(io, html)
end
