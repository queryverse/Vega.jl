# download javascript files

using BinDeps
@BinDeps.setup


# Vega-lite version v2.0.0-beta.4, commit dac71df

uschema = "https://github.com/vega/vega-lite/blob/dac71dffbfcf28ff0ff406b94f0a294f1b0a4670/build/vega-lite-schema.json"
# uschema = "https://vega.github.io/schema/vega-lite/v2.json"

ud3       = "https://d3js.org/d3.v3.min.js"  # FIXME find URL with stable D3 version
uvega     = "https://cdnjs.cloudflare.com/ajax/libs/vega/3.0.0-beta.33/vega.min.js"
uvegalite = "https://cdnjs.cloudflare.com/ajax/libs/vega-lite/2.0.0-beta.4/vega-lite.min.js"
uembed    = "https://cdnjs.cloudflare.com/ajax/libs/vega-embed/3.0.0-beta.17/vega-embed.min.js"

destdir      = joinpath(dirname(@__FILE__), "lib")

run(@build_steps begin
  CreateDirectory(destdir, true)
  FileDownloader(uschema,   joinpath(destdir, basename(uschema)))
  FileDownloader(ud3,       joinpath(destdir, basename(ud3)))
  FileDownloader(uvega,     joinpath(destdir, basename(uvega)))
  FileDownloader(uvegalite, joinpath(destdir, basename(uvegalite)))
  FileDownloader(uembed,    joinpath(destdir, basename(uembed)))
end)

# install NodeJS modules

using NodeJS
using Compat

run(Cmd(`$(npm_cmd()) install`, dir=@__DIR__))
