####################################################################
#  JSON plot spec validation
####################################################################

function _conforms(x, ps::String, t::DataType)
  isa(x, t) && return
  throw("expected '$t' got '$(typeof(x))' in $ps")
end

conforms(x, ps::String, d::IntDef)    = _conforms(x, ps, Int)
conforms(x, ps::String, d::NumberDef) = _conforms(x, ps, Number)
conforms(x, ps::String, d::BoolDef)   = _conforms(x, ps, Bool)
conforms(x, ps::String, d::RefDef)    = conforms(x, ps, defs[d.ref])
conforms(x, ps::String, d::VoidDef)   = nothing

function conforms(x, ps::String, d::StringDef)
  _conforms(x, ps, String)
  if length(d.enum) > 0
    if ! (x in d.enum)
      svalid = "[" * join(collect(d.enum)) * "]"
      throw("'$x' is not one of $svalid in $ps")
    end
  end
  nothing
end

function conforms(x, ps::String, d::ArrayDef)
  _conforms(x, ps, Vector)
  for e in x
    any( tryconform([d], [ps], spec.items) ) && continue
    throw("element $x in array is not allowed in $ps")
  end
  nothing
end


function conforms(d, ps::String, spec::ObjDef)
  isa(d, Dict) || throw("expected object got '$d' in $ps")
  for (k,v) in d
    haskey(spec.props, k) || throw("unexpected param '$k' in $ps")
    conforms(v, ps * k * "(..", spec.props[k])
  end
  for k in spec.required
    haskey(d, k) || throw("required param '$k' missing in $ps")
  end
end

function tryconform(d, ps::String, spec::SpecDef)
  try
    conforms(d, ps, spec)
  catch e
    return false
  end
  true
end

function conforms(d, ps::String, spec::UnionDef)
  causes = String[]
  for s in spec.items
    tryconform(d, ps, s) && return
    try
      conforms(d, ps, s)
    catch e
      println(e)
      isa(e, String) && push!(causes, e)
    end
  end
  scauses = join(unique(causes), ", ")
  throw("no valid specification found for $ps , possibles causes are : $scauses")
end

#
# ev=0
# try
#   conforms(456, VLPath(["test"]), BoolDef(""))
# catch e
#   ev = e
# end
#
# typeof(ev)
#
# pd, spec = Main.A.pd, defs["plot"]
#
#
# conforms(pd, VLPath(["plot"]), spec)
#
# d, ps, spec = pd, VLPath(["plot"]), spec.items[1]
# conforms(pd, VLPath(["plot"]), spec)
#
# d, ps, spec = d["encoding"], VLPath(["plot"]), spec.props["encoding"]
# conforms(d, VLPath(["plot"]), spec)
#
# d, ps, spec = d["x"], VLPath(["plot"]), defs[spec.ref].props["x"]
# conforms(d, VLPath(["plot"]), spec)
# conforms(d, VLPath(["test"]), defs["plot"])
#
# tryconform.([d], [ps], spec.items)
#
# tryconform(d, ps, spec.items[1])
# tryconform(d, ps, spec.items[2])
#
# conforms(d, VLPath(["plot"]), spec.items[1])
# conforms(d, VLPath(["plot"]), spec.items[2])
#
# conforms(d, VLPath(["plot"]), defs[spec.items[2].ref])
#
# d, ps, spec = d["bin"], VLPath(["plot"]), defs[spec.items[2].ref].props["bin"]
# conforms(d, VLPath(["plot"]), spec)
# conforms(d, VLPath(["plot"]), spec.items[1])
# conforms(d, VLPath(["plot"]), spec.items[2])
#
# tryconform.([d], [ps], spec.items)
# tryconform(d, VLPath(["plot"]), spec.items[1])
#
#
# tryconform(pd, VLPath(["plot"]), spec.items[2])
# tryconform(pd, VLPath(["plot"]), spec.items[3])
# tryconform(pd, VLPath(["plot"]), spec.items[4])
# tryconform(pd, VLPath(["plot"]), spec.items[5])
