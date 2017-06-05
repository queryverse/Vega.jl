###################################################################
#   function documentation
###################################################################

function prettydesc(desc::String)
  res = replace(desc, "\n\n__Default value:__", " *Default:*")
  res = replace(res, "\n\n__Note:__", " *Note:*")
  res = replace(res, "\n\n__Applicable for:__", " *Applicable for:* ")
  res
end

function mkdoc(spec::UnionDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  push!(docstr, "One of : ")
  for (i,v) in enumerate(spec.items)
    fs = needsfunction(v) ? "`$context(<keyword args..>)`" : "`$context=...`"
    push!(docstr, "- _case #$(i)_ $fs $(prettydesc(v.desc))")
    append!(docstr, mkdoc(v, Symbol(""), 2))
  end
  repeat(" ", indent) .* docstr
end

# spec = def
# context, indent = :test , 0
function mkdoc(spec::ObjDef, context::Symbol, indent)
  docstr = String[]
  spec.desc != "" && push!(docstr, spec.desc, "")
  for (k,v) in spec.props
    sk = Symbol(k)
    # println(sk)
    sk = get(sp2jl, sk, sk)
    if haskey(funcs, sk)
      push!(docstr, "- `$sk` : *see help for `$sk()`*")
    else
      dstrs = mkdoc(v, sk, 2)
      dstrs[1] = "- `$sk` : " * dstrs[1]
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
  push!(docstr, "(Int) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::NumberDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Number) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::StringDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(String) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::BoolDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Boolean) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::ArrayDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Array of $(typeof(spec.items))) $(prettydesc(spec.desc))")
  repeat(" ", indent) .* docstr
end

function mkdoc(spec::VoidDef, context::Symbol, indent)
  docstr = String[]
  push!(docstr, "(Void) ")
  repeat(" ", indent) .* docstr
end

# (sfn, dvs) = first(filter((k,v) -> k == :plot, funcs))
# (def, fns) = first(drop(dvs,4))
# typeof(def)
# mkdoc(def, sfn, 0)
#
# for (sfn, dvs) in funcs
#   sfn == :plot && continue  # FIXME : circular ref in plot definition
#
#   println(sfn)
#   docstr = String[]
#   for (def, fns) in dvs
#     fns2 = [ a==["plot","*"] ? "plot" : lcfirst(a[end]) for a in fns]
#     fns2 = [ get(sp2jl, s, s) for s in fns2 ]
#     flist = join("`" .* unique(fns2) .* "()`", ", ", " and ")
#     push!(docstr, "## `$sfn` when in $flist")
#     append!(docstr, mkdoc(def, sfn, 0))
#     push!(docstr, "")
#   end
#   fulldoc = join(rstrip.(docstr), "\n")
#   # println(fulldoc)
#   # println()
#   # println()
#   eval(:( @doc $fulldoc $sfn ))
# end
