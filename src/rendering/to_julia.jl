function print_datavaluesnode_as_julia(io, it, col_names)
    print(io, "[")

    for (row_index, row) in enumerate(it)
        row_index == 1 || print(io, ",")
        print(io, "{")

        for (col_index, col_value) in enumerate(row)
            col_index == 1 || print(io, ",")
            print(io, col_names[col_index])
            print(io, "=")
            print(io, col_value isa DataValue ? get(col_value, nothing) : col_value)
        end

        print(io, "}")
    end

    print(io, "]")
end

function print_vspec_as_julia(io::IO, d::DataValuesNode, indent, indent_level, newlines, include_data)
    col_names = collect(keys(d.columns))
    it = TableTraitsUtils.create_tableiterator(collect(values(d.columns)), col_names)

    if include_data == :short
        print(io, "...")
    else
        print_datavaluesnode_as_julia(io, it, col_names)
    end
end

function print_vspec_as_julia(io::IO, vect::AbstractVector, indent, indent_level, newlines, include_data)    
    for (i, v) in enumerate(vect)
        i > 1 && print(io, ",", newlines ? "\n" : "")
        if v isa AbstractDict
            print(io, " "^(indent * indent_level), "{")
            newlines && println(io)
            print_vspec_as_julia(io, v, indent, indent_level + 1, newlines, include_data)
            newlines && println(io)
            print(io, " "^(indent * indent_level), "}")
        elseif v isa AbstractVector
            print(io, "[")
            newlines && println(io)
            print_vspec_as_julia(io, v, indent, indent_level + 1, newlines, include_data)
            newlines && println(io)
            print(io, " "^(indent * indent_level), "]")
        elseif v isa DataValuesNode
            print_vspec_as_julia(io, v, indent, indent_level, newlines, include_data)
        elseif v isa AbstractString || v isa Symbol
            print(io, " "^(indent * indent_level))
            print(io, "\"")
            print(io, string(v))
            print(io, "\"")
        else
            print(io, " "^(indent * indent_level))
            print(io, v)
        end
    end
end

function print_vspec_as_julia(io::IO, dict::AbstractDict, indent, indent_level, newlines, include_data)
    dict = (include_data == :short || include_data) ? dict : OrderedDict{String,Any}(i for i in dict if i[1] != "data")
    for (i, (k, v)) in enumerate(dict)
        i > 1 && print(io, ",", newlines ? "\n" : "")
        print(io, " "^(indent * indent_level), k)
        print(io, "=")
        if v isa AbstractDict
            print(io, "{")
            newlines && println(io)
            print_vspec_as_julia(io, v, indent, indent_level + 1, newlines, include_data)
            newlines && println(io)
            print(io, " "^(indent * indent_level), "}")
        elseif v isa AbstractVector
            print(io, "[")
            newlines && println(io)
            print_vspec_as_julia(io, v, indent, indent_level + 1, newlines, include_data)
            newlines && println(io)
            print(io, " "^(indent * indent_level), "]")
        elseif v isa AbstractString || v isa Symbol
            print(io, "\"")
            print(io, string(v))
            print(io, "\"")
        elseif v isa DataValuesNode
            print_vspec_as_julia(io, v, indent, indent_level + 1, newlines, include_data)
        else
            print(io, v)
        end
    end
end

"""
    printrepr(io, v::AbstractVegaSpec; indent=nothing, include_data=false)

Print representation of a Vega or VegaLite spec `v` parsable by Julia.
The `include_data` keyword controls whether the `data` element is included
in the output. `indent` controls whether the code is printed in one line
(indent=nothing), or as multiple lines with indentation (by passing an
`Int` to `indent`).
"""
function printrep end

function printrepr(io::IO, v::VGSpec; indent=nothing, include_data=false)
    newlines = indent === nothing ? false : true
    indent = indent === nothing ? 0 : indent

    print(io, "@vgplot(")
    newlines && println(io)
    print_vspec_as_julia(io, getparams(v), indent, 1, newlines, include_data)
    newlines && println(io)
    print(io, ")")
end
