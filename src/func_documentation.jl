###################################################################
#   function documentation
###################################################################

function prettydesc(desc::String)
  res = replace(desc, "\n", " ") # remove all CR because they break formatting
  res = replace(res, "__", "*")  # markdown italic compatibilty issue ?
  res
end

function prettytype(typ::SpecDef)
  isa(typ, IntDef) && return "Int"
  isa(typ, NumberDef) && return "Number"
  isa(typ, StringDef) && return "String/Symbol"
  isa(typ, BoolDef) && return "Bool"
  isa(typ, VoidDef) && return "Void"
  warn("[prettytype] unmamanged type $(typeof(typ))")
  "???"
end

function mkdoc(spec::UnionDef, context::Symbol, indent)
  docstr = String[]

  # if all are simple types use a short format
  if all( !needsfunction(s) for s in spec.items )
    tstr = join(prettytype.(spec.items), ", ", " or ")
    push!(docstr, "($tstr) $(prettydesc(spec.desc))")

  else # case 1, case 2 format
    items = filter(s -> !isa(s, VoidDef), spec.items) # skip voids
    length(items) == 1 && return mkdoc(items[1], context, indent)

    spec.desc != "" && push!(docstr, prettydesc(spec.desc), "")
    push!(docstr, "One of : ")
    for (i,v) in enumerate(items)
      isa(v, VoidDef) && continue
      fs = needsfunction(v) ? "`$context(<keyword args..>)`" : "`$context=...`"
      push!(docstr, "- *case #$(i)* $fs $(prettydesc(v.desc))")
      append!(docstr, mkdoc(v, Symbol(""), 2))
    end
  end
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::ObjDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, prettydesc(spec.desc), "")
  for (k,v) in spec.props
    sk = get(sp2jl, Symbol(k), Symbol(k))
    if haskey(funcs2, jlfunc(sk))
      push!(docstr, "- `$sk` : *see help for `$(jlfunc(sk))()`*")
    else
      dstrs = mkdoc(v, sk, 2)
      dstrs[1] = "- `$sk` : " * dstrs[1]
      append!(docstr, dstrs)
    end
  end
  repeat(" ", indent) .* docstr
end

# There are circular references (in LayerSpec and RepeatSpec) that we
# should not get stuck into. Doc creation will keep track of definitions
# explored and stop when a RefSpec has already been seen
refpath = String[]

function mkdoc(spec::RefDef, context::Symbol, indent)
  spec.ref in refpath && return ["... see above ..."]
  push!(refpath, spec.ref)
  docstr = mkdoc(defs[spec.ref], context, indent)
  pop!(refpath)
  docstr
end

function _mkdoc(spec::SpecDef, indent)
  docstr = String[]
  push!(docstr, "($(prettytype(spec))) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

mkdoc(spec::IntDef, context::Symbol, indent)    = _mkdoc(spec, indent)
mkdoc(spec::NumberDef, context::Symbol, indent) = _mkdoc(spec, indent)
mkdoc(spec::StringDef, context::Symbol, indent) = _mkdoc(spec, indent)
mkdoc(spec::BoolDef, context::Symbol, indent)   = _mkdoc(spec, indent)
mkdoc(spec::VoidDef, context::Symbol, indent)   = _mkdoc(spec, indent)

function mkdoc(spec::ArrayDef, context::Symbol, indent)
  docstr = String[]
  tstr = prettytype(spec.items)
  push!(docstr, "(Array of $tstr) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

####

sfn = :vlaxis
dvs = funcs2[sfn]
docstr = String[]
# dvs[1][1] == dvs[2][1]
# def, parentdef = first(dvs)
for (def, parentdef) in dvs
  fns2 = get(def2funcs, parentdef, Symbol("???"))
  fns2 = [ string(s) for s in fns2 ]
  flist = join("`" .* unique(fns2) .* "()`", ", ", " and ")
  push!(docstr, "## `$sfn` when in $flist")
  append!(docstr, mkdoc(def, sfn, 0))
  push!(docstr, "")
end
fulldoc = join(rstrip.(docstr), "\n")
eval(:( @doc $fulldoc $sfn ))
vlaxis
vlvalues



def, fns = first(drop(dvs,1))
fns2 = [ a==["plot","*"] ? "plot" : lcfirst(a[end]) for a in fns]
fns2 = [ string(jlfunc(s)) for s in fns2 ]
flist = join("`" .* unique(fns2) .* "()`", ", ", " and ")
fns

# inverse tree for defs
for (k,v) in defs



def2func = Dict{SpecDef, Vector{Symbol}}()
for (sfn, dvs) in funcs
  for def in keys(dvs)
    if haskey(def2func, def)
      push!(def2func[def], sfn)
    else
      def2func[def] = Symbol[sfn]
    end
  end
end

defparents = Dict{SpecDef, Vector{SpecDef}}()
for (k,v) in defs
  if isa(v, ObjDef)
    for (prop, def) in v.props
      if haskey(defparents, def)
        push!(defparents[def], v)
      else
        defparents[def] = v
      end
    end
  elseif isa(v, UnionDef)
    for def in v.items
      if haskey(defparents, def)
        push!(defparents[def], v)
      else
        defparents[def] = v
      end
    end


  for (prop, def) in v.props
    needsfunction(def) || continue

    if haskey(def2func, def)
      push!(def2func[def], k)
    else
      def2func[def] = Symbol[k]
    end
  end
end


extrema( length(v) for v in values(def2func) )





def2func[def]

import Base: hash
type AB ; x ; end
hash(x::AB) = 12

hash(AB("abcd"))
AB("abcd") == AB(456)

==(x::AB, y::AB) = hash(x) == hash(y)

ttt = Set{AB}()
push!(ttt, AB("abcd"))
push!(ttt, AB("12"))
ttt
length(ttt)

ttt = Dict(AB(12) => 12)
ttt[AB("abcd")]


println(docstr[2])




funcs[:plot]

spe = defs["AxisConfig"].props["titleFontWeight"]
all( !needsfunction(s) for s in spe.items )


defs["AxisConfig"]
defs["Axis"]

defs["PositionFieldDef"]

defs["VgAxisEncode"]


vlencode


########################################################

for (sfn, dvs) in funcs
  docstr = String[]
  for (def, fns) in dvs
    fns2 = [ a==["plot","*"] ? "plot" : lcfirst(a[end]) for a in fns]
    fns2 = [ get(sp2jl, s, s) for s in fns2 ]
    flist = join("`" .* unique(fns2) .* "()`", ", ", " and ")
    push!(docstr, "## `$sfn` when in $flist")
    append!(docstr, mkdoc(def, sfn, 0))
    push!(docstr, "")
  end
  fulldoc = join(rstrip.(docstr), "\n")
  # println(fulldoc)
  # println()
  # println()
  eval(:( @doc $fulldoc $sfn ))
end
