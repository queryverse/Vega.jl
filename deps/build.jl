# download javascript files

using BinDeps
@BinDeps.setup

# uschema = "https://vega.github.io/schema/vega-lite/v2.json"

ud3       = "https://d3js.org/d3.v4.min.js"  # FIXME find URL with stable D3 version
uvega     = "https://cdnjs.cloudflare.com/ajax/libs/vega/3.0.8/vega.js"
uvegalite = "https://cdnjs.cloudflare.com/ajax/libs/vega-lite/2.0.3/vega-lite.js"
uembed    = "https://cdnjs.cloudflare.com/ajax/libs/vega-embed/3.0.0-rc7/vega-embed.js"

destdir      = joinpath(@__DIR__, "lib")

run(@build_steps begin
  CreateDirectory(destdir, true)
  # FileDownloader(uschema,   joinpath(destdir, basename(uschema)))
  FileDownloader(ud3,       joinpath(destdir, basename(ud3)))
  FileDownloader(uvega,     joinpath(destdir, basename(uvega)))
  FileDownloader(uvegalite, joinpath(destdir, basename(uvegalite)))
  FileDownloader(uembed,    joinpath(destdir, basename(uembed)))
end)

# install NodeJS modules
using NodeJS
using Compat

run(Cmd(`$(npm_cmd()) install --production --no-bin-links --no-package-lock --no-optional`, dir=@__DIR__))
