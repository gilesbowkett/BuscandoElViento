module BuscandoElViento
  def vector_name(name)
    case name
    when String, Symbol
      "#{name}_search_vector".to_sym
    when Array
      "#{name.join("_")}_search_vector".to_sym
    end
  end
  def add_search_vector(table, column)
    add_column(table, vector_name(column), "tsvector")
  end
  def remove_search_vector(table, column)
    remove_column(table, vector_name(column))
  end
end

