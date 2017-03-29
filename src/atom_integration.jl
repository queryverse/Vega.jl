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

  # if package PhantomJS is present redirect rendering to Juno's plot pane
  try
    import PhantomJS

    Media.media(VegaLiteVis, Media.Plot)

    Media.render(e::Atom.Editor, plt::VegaLiteVis) =
      Media.render(e, nothing)

    function Media.render(pane::Atom.PlotPane, plt::VegaLiteVis)
      # write html to an IOBuffer()
      pio = IOBuffer()
      VegaLite.writehtml(pio, plt)
      seekstart(pio)

      # convert to png
      png = PhantomJS.renderhtml(pio, clipToSelector=".marks", format="png")

      Media.render(pane,
                   Atom.div(
                     Atom.img(src = "data:image/png;base64," * base64encode(png))))
    end
  end

end
