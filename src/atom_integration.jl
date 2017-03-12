######################################################################
#
#     Atom Integration
#
#     - Inhibits display of VegaLite plots in Atom to avoid having plots
#          sent twice to the browser
#
######################################################################

@require Atom begin  # define only if/when Atom is loaded

  import Atom, Media

  function Media.render(e::Atom.Editor, plt::VegaLiteVis)
    Media.render(e, nothing)
    show(plt)
  end

  # tests if wkhtmltoimage is in the path, if yes define rendering in plot pane
  # try
  #   run(`wkhtmltoimage -V`)
  #
  #   Media.media(VegaLiteVis, Media.Plot)
  #
  #   Media.render(e::Atom.Editor, plt::VegaLiteVis) =
  #     Media.render(e, nothing)
  #
  #   function Media.render(pane::Atom.PlotPane, plt::VegaLiteVis)
  #     # create a temporary file
  #     tmppath = string(tempname(), ".vegalite.html")
  #     open(tmppath, "w") do io
  #       writehtml(io, plt)
  #     end
  #
  #     sz = (400,400)
  #     png_fn = string(tempname(), ".png")
  #     run(`wkhtmltoimage -f png -q --width $(sz[1]) --height $(sz[2]) $tmppath $png_fn`)
  #
  #     Media.render(pane, Atom.div(Atom.img(src=png_fn)))
  #   end
  # end

end
