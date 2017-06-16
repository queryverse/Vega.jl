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
  isa(typ, AnyDef) && return "Any"
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
    # items = filter(s -> !isa(s, VoidDef), spec.items) # skip voids
    # length(items) == 1 && return mkdoc(items[1], context, indent)
    # items = filter(s -> !isa(s, VoidDef), spec.items) # skip voids
    length(spec.items) == 1 && return mkdoc(items[1], context, indent)

    spec.desc != "" && push!(docstr, prettydesc(spec.desc), "")
    push!(docstr, "One of : ")
    for (i,v) in enumerate(spec.items)
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
mkdoc(spec::AnyDef, context::Symbol, indent)    = _mkdoc(spec, indent)

function mkdoc(spec::ArrayDef, context::Symbol, indent)
  docstr = String[]
  tstr = prettytype(spec.items)
  push!(docstr, "(Array of $tstr) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end


########################################################

for (sfn, dvs) in funcs2
  docstr = String[]
  for (def, pset) in dvs
    fns2 = mapfoldl(e -> get(def2funcs, e, "???"), append!, [], collect(pset))
    fns2 = unique(string.(fns2))
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
