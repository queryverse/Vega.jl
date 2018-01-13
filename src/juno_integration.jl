######################################################################
#
#     Juno Integration
#
######################################################################

using Juno

media(VLSpec, Media.Plot)

Juno.@render Juno.PlotPane p::VLSpec begin
    HTML(stringmime("image/svg+xml", p))
end
