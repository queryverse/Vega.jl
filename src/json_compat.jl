# Compatibility shim for the JSON.jl 1.0 rewrite.
#
# JSON.jl 1.0 removed the `JSON.Writer` module (`show_json`, `Serialization`,
# `StructuralContext`) in favour of `StructUtils.lower`. Its presence is what we
# branch on; everything version specific in this package lives in this file.
const JSON_HAS_WRITER = isdefined(JSON, :Writer)

# JSON is not able to represent NaN/Inf. JSON.jl <1.0 silently wrote them as
# `null`, which is what vega and vega-lite expect for missing values, while
# JSON.jl >=1.0 throws unless `allownan=true`. Keep the old behaviour on both.
@static if JSON_HAS_WRITER
    json_print(io::IO, x) = JSON.print(io, x)
    json_print(io::IO, x, indent::Integer) = JSON.print(io, x, indent)
else
    json_print(io::IO, x) =
        JSON.json(io, x, allownan=true, nan="null", inf="null", ninf="null")
    json_print(io::IO, x, indent::Integer) =
        JSON.json(io, x, pretty=indent, allownan=true, nan="null", inf="null", ninf="null")
end

# JSON.jl >=1.0 parses into a `JSON.Object` rather than a `Dict`. Ask for an
# `OrderedDict` explicitly instead: that is what the spec types store, and it
# preserves the key order of the original document on every JSON.jl version.
json_parse(x) = JSON.parse(x, dicttype=OrderedDict{String,Any})
