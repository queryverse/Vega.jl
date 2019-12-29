function convert_curly_style_array(exprs, fragtype)
    res = Expr(:vect)

    for ex in exprs
        if ex isa Expr && ex.head==:braces
            push!(res.args, :( $(convert_curly_style(ex.args, fragtype)) ))
        else
            push!(res.args, esc(ex))
        end
    end

    return res
end

function convert_curly_style(exprs, fragtype)
    new_expr = :($fragtype(Any[], Dict{String,Any}()))

    pos_args = new_expr.args[2].args
    named_args = new_expr.args[3].args

    for ex in exprs
        if ex isa Expr && ex.head==:(=)
            if ex.args[2] isa Expr && ex.args[2].head==:braces
                push!(named_args, :( $(string(ex.args[1])) => $(convert_curly_style(ex.args[2].args, fragtype)) ))
            elseif ex.args[2] isa Expr && ex.args[2].head==:vect
                push!(named_args, :( $(string(ex.args[1])) => $(convert_curly_style_array(ex.args[2].args, fragtype)) ))
            else
                push!(named_args, :( $(string(ex.args[1])) => $(esc(ex.args[2])) ))
            end
        elseif ex isa Expr && ex.head==:braces
            push!(pos_args, convert_curly_style(ex.args, fragtype))
        else
            push!(pos_args, esc(ex))
        end
    end

    return new_expr
end

macro vlplot(ex...)
    new_ex = convert_curly_style(ex, VLFrag)

    return :( VegaLite.VLSpec(convert_frag_tree_to_dict(fix_shortcut_level_spec($new_ex))) )
end

macro vgplot(ex...)
    new_ex = convert_curly_style(ex, VGFrag)

    return :( VegaLite.VGSpec(convert_frag_tree_to_dict(fix_shortcut_level_spec($new_ex))) )
end

macro vlfrag(ex...)
    new_ex = convert_curly_style(ex, VLFrag)

    return new_ex
end

macro vgfrag(ex...)
    new_ex = convert_curly_style(ex, VGFrag)

    return new_ex
end
