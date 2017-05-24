
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

  elseif length(spec) == 0
    return VoidDef()

  else
    warn("not a ref, 'AnyOf' and no type for $spec")
    return VoidDef()
  end
end

# toDef(spc["definitions"]["BaseSelectionDef"])

# tspc = spc["definitions"]["BaseSelectionDef"]["properties"]["bind"]["anyOf"][6]
#
# haskey(tspc, "additionalProperties")
# isa(tspc["additionalProperties"], Dict)
# toDef(tspc["additionalProperties"])
# haskey(tspc, "type")
#
# isa(get(tspc, "additionalProperties", false), Dict)
# toDef(tspc["additionalProperties"])

############

defs = Dict{String, SpecDef}()

# Add definitions
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

# Add definition for the base schema
defs["root"] = toDef(spc)


##############################################################################


conforms(x, d::IntDef)    = isa(x, Int64)
conforms(x, d::NumberDef) = isa(x, Number)
conforms(x, d::BoolDef)   = isa(x, Bool)
conforms(x, d::RefDef)    = isa(x, juliaTypeof(d.ref))
conforms(x, d::VoidDef)   = true

function conforms(x, d::StringDef)
  isa(x, String) || return false
  length(d.enum)==0 || x in d.enum || return false
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

# function conforms(x, d::ObjDef)
#   isa(x, Vector) || return false
#   any(xi -> !conforms(xi, d.items), x) && return false
#   true
# end

function wrapper(def::ObjDef, args...;kwargs...)

  # def = defs["DateTime"]
  # args = ["abcd"] ; kwargs=[(:day, "Monday")]
  pars = Dict{Symbol,Any}()

  # first map the kw args to the fields in the definitions
  for (f,v) in kwargs
    haskey(def.props, string(f)) || error("unexpected parameter $f")
    fdef = def.props[string(f)]
    conforms(v, fdef) || error("expecting a $ftyp for parameter $f, got $(typeof(v))")
    pars[f] = v
  end

  freefd = Set(setdiff(Symbol.(collect(keys(def.props))), keys(pars)) )

  for a in args
    okfd = filter(f -> conforms(a, def.props[string(f)]), freefd)
    # TODO : map to required params in priority ?

    if length(okfd) == 0
      error("could not map argument $a to any compatible field")
    elseif length(okfd) == 1
      pars[Symbol(first(okfd))] = a
      delete!(freefd, first(okfd))
    else
      error("argument $a cannot unambiguously be associated to an expected field")
    end
  end

  # check for required fields
  if length(def.required) > 0
    all( r -> Symbol(r) in keys(pars), def.required ) ||
      error("some required param missing")
  end

  JSON.json(pars)
end
