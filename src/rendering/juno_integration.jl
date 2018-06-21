######################################################################
#
#     Juno Integration
#
######################################################################

using Juno

media(VLSpec, Media.Plot)

Juno.@render Juno.PlotPane p::VLSpec{:plot} begin
    HTML(string("<div style=\"background-color:white\"", stringmime("image/svg+xml", p), "</div>"))
end

media(VGSpec, Media.Plot)

Juno.@render Juno.PlotPane p::VGSpec begin
    HTML(string("<div style=\"background-color:white\"", stringmime("image/svg+xml", p), "</div>"))
end
