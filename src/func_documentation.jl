###################################################################
#   function documentation
###################################################################

function mkdoc(spec::UnionDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  push!(docstr, "One of : ")
  for (i,v) in enumerate(spec.items)
    fs = needsfunction(v) ? "`$context(<keyword args..>)`" : "`$context=...`"
    push!(docstr, "   • _case #$(i)_ $fs $(v.desc)")
    append!(docstr, mkdoc(v, Symbol(""), 6))
  end
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::ObjDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  for (k,v) in spec.props
    sk = Symbol(k)
    sk = get(sp2jl, sk, sk)
    if haskey(funcs, sk)
      push!(docstr, "• `$sk` : *see help for `$sk()`*", "")
    else
      dstrs = mkdoc(v, sk, 3)
      dstrs[1] = "• `$sk` : " * dstrs[1]
      append!(docstr, dstrs)
    end
  end
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::RefDef, context::Symbol, indent)
  mkdoc(defs[spec.ref], context, indent)
end

function mkdoc(spec::IntDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Int) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::NumberDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Number) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::StringDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(String) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::BoolDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Boolean) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::ArrayDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Array of $(typeof(spec.items))) $(spec.desc)")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::VoidDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Void) ")
  repeat(" ", indent) .* docstr
end

# (sfn, dvs) = first(funcs)
# (def, fns) = first(dvs)
# unique(fns)
# ks = first(keys(def))
#
# ds = mkdoc(ks,:padding, 0)
# s = join(rstrip.(ds), "\n")
#
# mkdoc(NumberDef(""), :test, 0)
#
# @doc "$s" padding
# println(s)
# @doc(s, padding)

for (sfn, dvs) in funcs #take(funcs,3)
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
