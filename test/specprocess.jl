using JSON

fn = joinpath(dirname(@__FILE__), "v2.json")

spc = JSON.parsefile(fn)


#####################################################

function elemtype(typ::String)
  typ=="number" && return Number
  typ=="boolean" && return Bool
  typ=="integer" && return Int64
  typ=="string"  && return String
  typ=="array" && return Vector
  error("unknown spec type $typ")
end

function proploop(props::Dict)
  params = Dict{Symbol, NTuple{2}}()
  for (k,v) in props
    typ = parsetype(v)
    if isa(typ, Dict) # needs secondary def
      extensions = ["" ; 1:100]
      ext = extensions[findfirst(e -> !haskey(defs, "_$k$e"), extensions)]
      typname = "_$k$ext"
      defs[typname] = typ
      typ = typname
    end
    desc = get(v, "description", "")
    params[Symbol(k)] = (typ, desc)
  end
  params
end

function parsetype(spec::Dict)
  if haskey(spec, "type")
    typ = spec["type"]

    if isa(typ, Vector)
      typs = elemtype.(typ)
      return Union{typs...}

    elseif isa(typ, String)
      if typ == "object"
        haskey(spec, "properties") && return proploop(spec["properties"])

        return Void
      else
        return elemtype(typ)
      end
    end

    error("type $typ is neither an array nor a string")

  elseif haskey(spec, "\$ref")
    typ = split(spec["\$ref"], "/")[3]
    return typ

  else
    warn("not a ref and no type for $spec")
    return Void
  end
end


parsetype(spc["definitions"]["CellConfig"])

############

defs = Dict{String, Any}()

for (k,v) in spc["definitions"]
  def = parsetype(v)
  if def==nothing
    warn("no properties found for $k")
    continue
  end

  haskey(defs, k) && error("def $k already defined !")
  defs[k] = def
end

length(defs)

for (k,v) in defs
  println("#####  $k  #####")
  if isa(v, Dict)
    for (n,(t,d)) in v
      println("  - $n : $t ")
      isa(t, Type) || haskey(defs, t) || println("!!!! $t not defined !!!!")
    end
  else
    println("  = $v")
  end
  println()
end


for (n,(t,d)) in defs["AreaOverlay"]
  println("  - $n : $t ")
  isa(t, Type) || haskey(defs, t) || warn("$t not defined")
end


#################################################################


#####  ExtendedScheme  #####
  - name : String
  - count : Number
  - extent : Array{Any,1}

type VLSpec{T}
  json::String
end


VLSpec{Int64}("abcd")
VLSpec{:yo}("abcd")
VLSpec{"yo"}("abcd")

typeof(JSON.json(Dict(:cdf=>"yo")))

function wrapper(def::Dict, args...;kwargs...)
  # first map the kw args to the field in the definitions
  pars = Dict{Symbol,Any}()
  for (f,v) in kwargs
    haskey(def,f) || error("unexpected parameter $f")
    ftyp = def[f][1]
    isa(v, ftyp) || error("expecting a $ftyp for parameter $f, got $(typeof(v))")
    pars[f] = v
  end

  # try to guess where other parameters apply
  typs =   [ t for (f,(t,d)) in def ]
  fields = [ f for (f,(t,d)) in def ]
  utyps =  [ sum(t .== typs) == 1 && !haskey(pars, t) for t in typs ]

  for a in args
    idx = findfirst(i -> utyps[i] && isa(a, typs[i]), 1:length(typs))
    if idx == 0
      error("could not map argument $a to any expected field")
    else
      pars[fields[idx]] = a
      utyps[idx] = false
    end
  end

  JSON.json(pars)
end

function extendedScheme(args...;kwargs...)
  VLSpec{:extendedScheme}(wrapper(defs["ExtendedScheme"],
                          args...;kwargs...))
end

extendedScheme(15)
extendedScheme(15,"qsdf")
extendedScheme(15,"qsdf", 456)
extendedScheme(extent=15,"qsdf")
extendedScheme(extent=[15],"qsdf")


def = defs["ExtendedScheme"]
haskey(def, :extent)

defs["Encoding"]

module A
end

module A

for (k,v) in Main.defs
  if isa(v, Dict)
    println("defining $k")
    sk = Symbol(lowercase(k[1:1]) * k[2:end])
    @eval ($sk)(args...;kwargs...) = Main.VLSpec{$k}(Main.wrapper(defs[$k], args...;kwargs...))
  end
end

legend()
methods(legend)
@enum FRUIT apple=1 orange=2 kiwi=3
typeof(FRUIT)
typeof(apple)
apple

apple = "abcd"

end



function test(;kwargs...)
  Dict{Symbol,Any}(kwargs)
end

ttt = test(a=156, b="qsdf")
ttt[:b]


const
type VLInterpolate <: VLSpec



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
