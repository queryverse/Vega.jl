

mark_spec = Dict(:mark => AbstractString)


mark_bar()    = _mkvis(tuple(), mark_spec, [(:mark, "bar")])
mark_circle() = _mkvis(tuple(), mark_spec, [(:mark, "circle")])
mark_square() = _mkvis(tuple(), mark_spec, [(:mark, "square")])
mark_tick()   = _mkvis(tuple(), mark_spec, [(:mark, "tick")])
mark_line()   = _mkvis(tuple(), mark_spec, [(:mark, "line")])
mark_area()   = _mkvis(tuple(), mark_spec, [(:mark, "area")])
mark_point()  = _mkvis(tuple(), mark_spec, [(:mark, "point")])
mark_text()   = _mkvis(tuple(), mark_spec, [(:mark, "text")])
