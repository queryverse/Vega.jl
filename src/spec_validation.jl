####################################################################
#  JSON plot spec validation
####################################################################

conforms(x, d::IntDef)    = isa(x, Int64)
conforms(x, d::NumberDef) = isa(x, Number)
conforms(x, d::BoolDef)   = isa(x, Bool)
conforms(x, d::RefDef)    = conforms(x, defs[d.ref])
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

function conforms(x, d::ObjDef)
  isa(x, Vector) || return false
  any(xi -> !conforms(xi, d.items), x) && return false
  true
end
