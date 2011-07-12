module BuscandoElViento
  def add_search(table, columns)
    add_search_vector(table, columns)
    add_trigger(table, columns)
    add_index(table, columns)
  end
  def remove_search(table, columns)
    remove_search_vector(table, columns)
    remove_trigger(table, columns)
    remove_index(table, columns)
  end
end
