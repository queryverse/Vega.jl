function convert_curly_style_array(exprs)
    res = Expr(:vect)

    for ex in exprs
        if ex isa Expr && ex.head==:braces
            push!(res.args, :( $(convert_curly_style(ex.args)) ))
        else
            push!(res.args, esc(ex))
        end
    end

    return res
end

function convert_curly_style(exprs)
    new_expr = :(VegaLite.VLFrag(Any[], Dict{String,Any}()))

    pos_args = new_expr.args[2].args
    named_args = new_expr.args[3].args

    for ex in exprs
        if ex isa Expr && ex.head==:(=)
            if ex.args[2] isa Expr && ex.args[2].head==:braces
                push!(named_args, :( $(string(ex.args[1])) => $(convert_curly_style(ex.args[2].args)) ))
            elseif ex.args[2] isa Expr && ex.args[2].head==:vect
                push!(named_args, :( $(string(ex.args[1])) => $(convert_curly_style_array(ex.args[2].args)) ))
            else
                push!(named_args, :( $(string(ex.args[1])) => $(esc(ex.args[2])) ))
            end
        else
            push!(pos_args, esc(ex))
        end
    end

    return new_expr
end

macro vlplot(ex...)
    new_ex = convert_curly_style(ex)

    return :( VegaLite.VLSpec(fix_shortcut_level_spec($new_ex)) )
end

macro vlfrag(ex...)
    new_ex = convert_curly_style(ex)

    return new_ex
end
