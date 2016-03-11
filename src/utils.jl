###################################################################
#  Common definitions
###################################################################

type VegaLiteVis
    vis::Dict{}
end

+(a::VegaLiteVis, b::VegaLiteVis) = VegaLiteVis(softmerge(a.vis, b.vis))
*(a::VegaLiteVis, b::VegaLiteVis) = VegaLiteVis(merge(a.vis, b.vis))

function softmerge(a::Dict, b::Dict)
    ck = intersect(keys(a), keys(b))
    nd = merge(a, b)
    for k in ck
        nd[k] = softmerge(a[k], b[k])
    end
    nd
end
softmerge(a::Dict, b::Any) = a
softmerge(a::Any, b::Dict) = b
softmerge(a, b) = b

# build Dict from kwargs, checks against signature
function _mkdict(signature, properties)
  d = Dict()
  for (p,v) in properties
    haskey(signature, p) || error("unknown property $p")
    isa(v, signature[p]) || error("property $p : expected $(signature[p]), got $(typeof(v))")
    d[p] = v
  end
  d
end

function _mkvis(pos::Tuple, signature, properties)
  d = _mkdict(signature, properties)
  for k in reverse(pos)
    d = Dict(k => d)
  end
  VegaLiteVis(d)
end
