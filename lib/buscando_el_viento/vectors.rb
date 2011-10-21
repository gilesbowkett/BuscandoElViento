module BuscandoElViento
  def add_search_vector(table, column)
    add_column(table, vector_search_column_name_for(column), "tsvector")
  end
  def remove_search_vector(table, column)
    remove_column(table, vector_search_column_name_for(column))
  end
end

