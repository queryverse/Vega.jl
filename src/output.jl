######################################################################
#    Conversion to SVG, PNG, JPG files
######################################################################

function tofile(path::String, plt::VLPlot, format::String)
  pio = IOBuffer()
  VegaLite.writehtml(pio, A.plt)

  out = PhantomJS.renderhtml(seekstart(pio),
                             clipToSelector=".marks",
                             format=format)



end

png(path::String, plt::VLPlot) = tofile(path, plt, "png")
svg(path::String, plt::VLPlot) = tofile(path, plt, "svg")
jpg(path::String, plt::VLPlot) = tofile(path, plt, "jpg")
pdf(path::String, plt::VLPlot) = tofile(path, plt, "pdf")
