module BuscandoElViento
  def index_name(table, column) # FIXME: better variable names
    "index_#{table}_on_#{column}_search_vector"
  end

  # yes, we're overwriting ActiveRecord::Migration's add_index, which, in this
  # context, is less useful than it should be
  def add_index(table, column)
    execute <<-ADD_INDEX
CREATE INDEX #{index_name(table, column)}
ON #{table}
USING gin(search_vector);
ADD_INDEX
  end
end
