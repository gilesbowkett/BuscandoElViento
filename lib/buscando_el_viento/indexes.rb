module BuscandoElViento
  def index_name(table, column) # FIXME: better variable names
    "index_#{table}_on_#{column}_search_vector"
  end
end
