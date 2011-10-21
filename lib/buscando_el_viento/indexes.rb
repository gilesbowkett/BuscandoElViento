module BuscandoElViento
  def index_name(table, column) # FIXME: better variable names
    s = "#{table}_on_#{column}"
    s.gsub!(/_and_/, "_") if s.length > 26
    s.gsub!(/_on_/, "_") if s.length > 26
    s.gsub!(/search_vector/, "sv") if s.length > 26
    s = s.split("_").map {|w| w.length <= 3 ? w : w[0..w.length - 3]}.join("_") if s.length > 26
    while s.length > 26 do
      s = s[3..(s.length - 1)]
    end
    "index_" + s
  end

  def add_gin_index(table, columns, options = {})
    column = column_name_for(columns)
    execute <<-ADD_INDEX
CREATE INDEX #{index_name(table, column)}
ON #{table}
USING gin(#{column});
ADD_INDEX
  end

  # Remove_index Rails syntax doesnt work in PostgreSQL.
  # You dont need the "ON {table}" (http://www.commandprompt.com/ppbook/r26357)
  def remove_gin_index(table, columns)
    column = column_name_for(columns)
    execute "DROP INDEX #{index_name(table, column)}"
  end

end