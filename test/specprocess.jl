using JSON

fn = joinpath(dirname(@__FILE__), "v2.json")


spc = JSON.parsefile(fn)




spc1 = spc["definitions"]["FilterTransform"]








for (k,v) in spc["definitions"]
  println("$k :  ($(v["type"]))")
end


function _transsubtype(typ::String)
  typ=="number" && return Number
  typ=="boolean" && return Bool
  typ=="string" && return String
  typ=="array" && return Vector{Any}
  typ=="integer" && return Int64
  error("unknown spec type $typ")
end

function transtype(spec::Dict)
  if haskey(spec, "type")
    typ = spec["type"]
    isa(typ, String) && return _transsubtype(typ)

    if isa(typ, Vector)
      typs = _transsubtype.(typ)
      return Union{typs...}
    end

    error("Can't parse type $typ")
  elseif haskey(spec, "\$ref")
    typ = split(spec["\$ref"], "/")[3]
    return "VL" * typ
  else
    return Void
  end
end

function trans(name::String, sp::Dict)
  # doc = IOBuffer()
  # func = IOBuffer()
  # println(doc, "documentation")
  # haskey(sp, "description") && println(doc, sp["description"])
  # println(func, "function $name(")

  println("### $name ###")
  params = Dict{String, NTuple{2}}()
  if sp["type"] == "object"
    for (k,v) in sp["properties"]
      typ = transtype(v)
      desc = get(v, "description", "")
      params[lowercase(k)] = (typ, desc)
      println("  - $k : $typ")
    end
    println()
  else
    println("  $(sp["type"])")
    println()
  end

end



function proploop(props::Dict)
  params = Dict{String, NTuple{2}}()
  for (k,v) in props
    typ = parsedef(v, k)
    desc = get(v, "description", "")
    params[k] = (typ, desc)
  end
  params
end

function parsedef(spec::Dict, namehint::String)
  println("parsedef $namehint")
  if haskey(spec, "type")
    typ = spec["type"]
    if isa(typ, Vector)
      typs = _transsubtype.(typ)
      return Union{typs...}
    elseif isa(typ, String)
      typ != "object" && return _transsubtype(typ)

      extensions = ["" ; 1:100]
      ext = extensions[findfirst(ext -> !haskey(defs, "$namehint$ext"), extensions)]
      typname = "$namehint$ext"
      if haskey(spec, "properties")
        defs[typname] = proploop(spec["properties"])
      end

      return typname
    end

    error("Can't parse type $typ")

  elseif haskey(spec, "\$ref")
    typ = split(spec["\$ref"], "/")[3]
    return typ

  else
    return Void
  end
end

defs = Dict{String, Any}()

for (k,v) in spc["definitions"]
  parsedef(v, k)
end

length(defs)

for (k,v) in defs
  println("#####  $k  #####")
  if isa(v, Dict)
    for (n,(t,d)) in v
      print("  - $n : $t ")
      if !isa(t, Type)
        print(haskey(defs, t) ? "(ok found)" : "(not found)")
      end
      println()
    end
  else
    println("  = $v")
  end
  println()
end


haskey(defs, "Scale")

namehint = "Scale"
findfirst(ext -> !haskey(defs, "$namehint$ext"), ["" ; 1:100])
map(ext -> !haskey(defs, "$namehint$ext"), ["" ; 1:5])


trans("bin", spc1)

spec = spc["definitions"]["Axis"]["properties"]["orient"]

spec = spc["definitions"]["LayerSpec"]["properties"]



for (k,v) in spc["definitions"]
  trans(k, v)
end
