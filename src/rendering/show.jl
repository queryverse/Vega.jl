function Base.show(io::IO, m::MIME"text/plain", v::AbstractVegaSpec)
    Vega.printrepr(io, v, indent=4, include_data=:short)
    return
end

function Base.show(io::IO, v::AbstractVegaSpec)
    if !get(io, :compact, true)
        Vega.printrepr(io, v, include_data=:short)
    else
        print(io, summary(v))
    end
    return
end

function convert_vg_to_x(v::VGSpec, script)
    full_script_path = joinpath(vegalite_app_path, "node_modules", "vega-cli", "bin", script)
    p = open(Cmd(`$(nodejs_cmd()) $full_script_path -l error`, dir=vegalite_app_path), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.exitcode != 0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

function convert_vg_to_svg(v::VGSpec)
    vg2svg_script_path = joinpath(vegalite_app_path, "vg2svg.js")
    p = open(Cmd(`$(nodejs_cmd()) $vg2svg_script_path`, dir=vegalite_app_path), "r+")
    writer = @async begin
        our_json_print(p, v)
        close(p.in)
    end
    reader = @async read(p, String)
    wait(p)
    res = fetch(reader)
    if p.exitcode != 0
        throw(ArgumentError("Invalid spec"))
    end
    return res
end

    Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.vega.v5+json")}) = true

function Base.show(io::IO, m::MIME"application/vnd.vega.v5+json", v::VGSpec)
    our_json_print(io, v)
end

function Base.show(io::IO, m::MIME"image/svg+xml", v::VGSpec)
    print(io, convert_vg_to_svg(v))
end

function Base.show(io::IO, m::MIME"application/pdf", v::VGSpec)
    if vegalite_app_includes_canvas
        print(io, convert_vg_to_x(v, "vg2pdf"))
    else
        error("Not yet implemented.")
        # svgstring = convert_vg_to_svg(v)

        # r = Rsvg.handle_new_from_data(svgstring)
        # d = Rsvg.handle_get_dimensions(r)

        # cs = Cairo.CairoPDFSurface(io, d.width,d.height)
        # try
        #     c = Cairo.CairoContext(cs)
        #     Rsvg.handle_render_cairo(c,r)
        # finally
        #     Cairo.finish(cs)
        # end
    end
end

# function Base.show(io::IO, m::MIME"application/eps", v::VGSpec)
#     svgstring = convert_vg_to_svg(v)

#     r = Rsvg.handle_new_from_data(svgstring)
#     d = Rsvg.handle_get_dimensions(r)

#     cs = Cairo.CairoEPSSurface(io, d.width,d.height)
#     try
#         c = Cairo.CairoContext(cs)
#         Rsvg.handle_render_cairo(c,r)
#     finally
#         Cairo.finish(cs)
#     end
# end

function Base.show(io::IO, m::MIME"image/png", v::VGSpec)
    if vegalite_app_includes_canvas
        print(io, convert_vg_to_x(v, "vg2png"))
    else
        error("Not yet implemented.")
        # svgstring = convert_vg_to_svg(v)

        # r = Rsvg.handle_new_from_data(svgstring)
        # d = Rsvg.handle_get_dimensions(r)

        # cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32)
        # c = Cairo.CairoContext(cs)
        # Rsvg.handle_render_cairo(c,r)
        # Cairo.write_to_png(cs,io)
    end
end

function Base.show(io::IO, m::MIME"application/vnd.julia.fileio.htmlfile", v::VGSpec)
    writehtml_full(io, v)
end

function Base.show(io::IO, m::MIME"application/prs.juno.plotpane+html", v::VGSpec)
    writehtml_full(io, v)
end

Base.showable(m::MIME"text/html", v::VGSpec) = isdefined(Main, :PlutoRunner)
function Base.show(io::IO, m::MIME"text/html", v::VGSpec)
    writehtml_partial_script(io, v)
end
