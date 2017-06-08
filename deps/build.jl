using NodeJS
using Compat

run(Cmd(`$(npm_cmd()) install`, dir=@__DIR__))
