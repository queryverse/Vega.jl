######################################################################
#
#     Atom Integration
#
#     - Inhibits display of VegaLite plots in Atom to avoid having plots
#          sent twice to the browser
#
######################################################################

@require Atom begin

  import Atom, Media

  function Media.render(e::Atom.Editor, plt::VegaLiteVis)
    Media.render(e, nothing)
    show(plt)
  end

  # if package Wkhtmltox is present redirect rendering to Juno's plot pane
  try
    import Wkhtmltox

    Media.media(VegaLiteVis, Media.Plot)

    Media.render(e::Atom.Editor, plt::VegaLiteVis) =
      Media.render(e, nothing)

    function Media.render(pane::Atom.PlotPane, plt::VegaLiteVis)
      # create a temporary file
      tmppath = string(tempname(), ".vegalite.html")
      open(tmppath, "w") do io
        writehtml(io, plt)
      end

      png_fn = string(tempname(), ".png")

      Wkhtmltox.img_init(1)
      is = Wkhtmltox.ImgSettings("in" => tmppath,
                                 "out" => png_fn,
                                 "fmt" => "png")  # png format output
      conv = Wkhtmltox.ImgConverter(is)
      Wkhtmltox.run(conv)

      conv = nothing
      Wkhtmltox.img_deinit()

      Media.render(pane, Atom.div(Atom.img(src=png_fn)))
    end
  end

end
