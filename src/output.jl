######################################################################
#    Conversion to SVG, PNG, JPG files
######################################################################

function tofile(path::String, plt::VLSpec{:plot}, format::String)
  pio = IOBuffer()
  VegaLite.writehtml(pio, A.plt)

  out = PhantomJS.renderhtml(seekstart(pio),
                             clipToSelector=".marks",
                             format=format)

end

png(path::String, plt::VLSpec{:plot}) = tofile(path, plt, "png")
svg(path::String, plt::VLSpec{:plot}) = tofile(path, plt, "svg")
jpg(path::String, plt::VLSpec{:plot}) = tofile(path, plt, "jpg")
pdf(path::String, plt::VLSpec{:plot}) = tofile(path, plt, "pdf")
