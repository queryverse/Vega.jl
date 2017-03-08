@require DataFrames begin  # define only if/when Atom is loaded

  import DataFrames.DataFrame

  """
  Sets the data source using a DataFrame
  `data_values(df::DataFrame)`

  Adds all the columns of `df` to the data field.
  """
  function data_values(df::DataFrame)
    vs = Any[]
    for n in names(df)
        push!(vs, (n, collect(df[n])) )
    end
    data_values(;vs...)
  end

end
