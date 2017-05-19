module A
end



using JSON

fn = joinpath(dirname(@__FILE__), "v2.json")

spc = JSON.parsefile(fn)


#####################################################

abstract SpecDef

type ObjDef <: SpecDef
  desc::String
  props::Dict{String, SpecDef}
  addprops::SpecDef
  required::Set{String}
end

type NumberDef <: SpecDef
  desc::String
end

type IntDef <: SpecDef
  desc::String
end

type StringDef <: SpecDef
  desc::String
  enum::Set{String}
end

type BoolDef <: SpecDef
  desc::String
end

type ArrayDef <: SpecDef
  desc::String
  items::SpecDef
end

type UnionDef <: SpecDef
  desc::String
  items::Vector
end

type RefDef <: SpecDef
  desc::String
  ref::String
end

function elemtype(typ::String)
  typ=="number"  && return NumberDef("")
  typ=="boolean" && return BoolDef("")
  typ=="integer" && return IntDef("")
  typ=="string"  && return StringDef("", Set{String}())
  error("unknown elementary type $typ")
end

UnionDef(spec::Dict)  = UnionDef(get(spec, "description", ""),
                                 elemtype.(spec["type"]))

NumberDef(spec::Dict) = NumberDef(get(spec, "description", ""))

IntDef(spec::Dict)    = IntDef(get(spec, "description", ""))

StringDef(spec::Dict) = StringDef(get(spec, "description", ""),
                                  Set{String}(get(spec, "enum", String[])))

BoolDef(spec::Dict)   = BoolDef(get(spec, "description", ""))

RefDef(spec::Dict)    = RefDef(get(spec, "description", ""),
                               split(spec["\$ref"], "/")[3])

ArrayDef(spec::Dict)  = ArrayDef(get(spec, "description", ""),
                                 toDef(spec["items"]))


end

type VoidDef <: SpecDef ; end

#####################################################

function toDef(spec::Dict)
  if haskey(spec, "type")
    typ = spec["type"]

    isa(typ, Vector) && return UnionDef(spec)

    if isa(typ, String)
      typ=="null"    && return VoidDef()
      typ=="number"  && return NumberDef(spec)
      typ=="boolean" && return BoolDef(spec)
      typ=="integer" && return IntDef(spec)
      typ=="string"  && return StringDef(spec)
      typ=="array"  && return ArrayDef(spec)

      if typ == "object"
        ret = ObjDef(get(spec, "description", ""),
                     Dict{String, SpecDef}(),
                     VoidDef(),
                     Set{String}(get(spec, "required", String[])))

        if haskey(spec, "properties")
          for (k,v) in spec["properties"]
            ret.props[k] = toDef(v)
          end
        end

        if haskey(spec, "additionalProperties") && isa(spec["additionalProperties"], Dict)
          ret.addprops = toDef(spec["additionalProperties"])
        end

        return ret
      end

      error("unknown type $typ")
    end

    error("type $typ is neither an array nor a string")

  elseif haskey(spec, "\$ref")
    return RefDef(spec)

  elseif haskey(spec, "anyOf")
    return UnionDef(get(spec, "description", ""),
                    toDef.(spec["anyOf"]))

  # elseif haskey(spec, "additionalProperties") && isa(spec["additionalProperties"], Dict)
  #   println("here")
  #   return toDef(spec["additionalProperties"])

  elseif length(spec) == 0
    return VoidDef()

  else
    warn("not a ref, 'AnyOf' and no type for $spec")
    return VoidDef()
  end
end

toDef(spc["definitions"]["BaseSelectionDef"])

# tspc = spc["definitions"]["BaseSelectionDef"]["properties"]["bind"]["anyOf"][6]
#
# haskey(tspc, "additionalProperties")
# isa(tspc["additionalProperties"], Dict)
# toDef(tspc["additionalProperties"])
# haskey(tspc, "type")
#
# isa(get(tspc, "additionalProperties", false), Dict)
# toDef(tspc["additionalProperties"])




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

defs = Dict{String, SpecDef}()

for (k,v) in spc["definitions"]
  println(k)
  def = toDef(v)
  if def==nothing
    warn("no properties found for $k")
    continue
  end

  haskey(defs, k) && error("def $k already defined !")
  defs[k] = def
end


# tspc = spc["definitions"]["LegendFieldDef<Field, number>"]
# toDef(tspc)
# for (k,v) in tspc["properties"]
#   println(k)
#   toDef(v)
# end


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

defs["AreaOverlay"]
defs["Encoding"]


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




conforms(x, d::IntDef)    = isa(x, Int64)
conforms(x, d::NumberDef) = isa(x, Number)
conforms(x, d::BoolDef)   = isa(x, Bool)
conforms(x, d::RefDef)    = isa(x, juliaTypeof(d.ref))
conforms(x, d::VoidDef)   = true

function conforms(x, d::StringDef)
  isa(x, String) || return false
  length(d.enum)>0 && (x in d.enum) || return false
  true
end

function conforms(x, d::ArrayDef)
  isa(x, Vector) || return false
  any(xi -> conforms(xi, d.items), x) || return false
  true
end

function conforms(x, d::UnionDef)
  any(di -> conforms(x, di), d.items) || return false
  true
end

function conforms(x, d::ObjDef)
  isa(x, Vector) || return false
  any(xi -> !conforms(xi, d.items), x) && return false
  true
end


equiv(a::SpecDef, b::SpecDef) = false
function equiv{T <: SpecDef}(a::T, b::T)
  T in [IntDef, NumberDef, BoolDef, VoidDef] && return true
  T == RefDef    && return a.ref == b.ref
  T == StringDef && return a.enum == b.enum
  T == ArrayDef && return equiv(a.items, b.items)
  false
end

equiv(IntDef(""), IntDef(""))
equiv(IntDef(""), NumberDef(""))


function wrapper(def::ObjDef, args...;kwargs...)

  # def = defs["DateTime"]
  pars = Dict{Symbol,Any}()

  # first map the kw args to the fields in the definitions
  for (f,v) in kwargs
    haskey(def.props,f) || error("unexpected parameter $f")
    fdef = def.props[f]
    conforms(v, fdef) || error("expecting a $ftyp for parameter $f, got $(typeof(v))")
    pars[f] = v
  end

  # try to guess where other parameters apply
  typs, fields = SpecDef[], String[]
  for (k,v) in def.props
    push!(typs, v) ; push!(fields, k)
  end
  noequiv = squeeze(sum(equiv.(typs, transpose(typs)),2),2) .< 2
  utyps = [ !haskey(pars, f) for f in fields] & noequiv
  # utyps =  [ sum(t .== typs) == 1 && !haskey(pars, t) for t in typs ]

  for a in args
    # idx = findfirst(i -> utyps[i] && isa(a, typs[i]), 1:length(typs))
    # a = 12
    # conforms(a, typs[2])
    # any(di -> conforms(a, di), typs[2].items)
    # typs[2]
    # fields[2]
    idx = findfirst(utyps & conforms.(a, typs))
    if idx == 0
      error("could not map argument $a to any expected field")
    else
      pars[Symbol(fields[idx])] = a
      utyps[idx] = false
    end
  end

  pars
end


defs["DateTime"]

wrapper(defs["DateTime"], 12,20)


##############################################################



function wrapper(def::Dict, args...;kwargs...)
  # first map the kw args to the fields in the definitions
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

dump(:(  abcd{:yo}(45) ))

def = defs["ExtendedScheme"]
haskey(def, :extent)

defs["Encoding"]

k = :abcd

:( ($k)(args) = $(Expr(:curly, :VLSpec, QuoteNode(k)))(10) )



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
