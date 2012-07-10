module BuscandoElViento
  def add_search(table, columns, options = {:fuzzy => false})
    add_search_vector(table, columns)
    add_trigger(table, columns, options)
    add_gin_index(table, vector_search_column_name_for(columns))
  end
  def remove_search(table, columns)
    remove_search_vector(table, columns)
    remove_trigger(table, columns)
    remove_gin_index(table, vector_search_column_name_for(columns))
  end
end
