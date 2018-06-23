using VegaLite
using Base.Test

@testset "MimeWrapper" begin

p = @vlplot(:point)

mp = VegaLite.MimeWrapper{MIME"image/png"}(p)

@test mimewritable("application/vnd.vegalite.v2+json", mp) == false
@test mimewritable("image/png", mp) == true

end
