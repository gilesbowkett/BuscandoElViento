module BuscandoElViento
  def trigger_name(table, column)
    "#{table}_#{vector_search_column_name_for(column)}_update"
  end

  def add_trigger(table, names, options = {:fuzzy => false})
    dictionary = if options[:fuzzy]
      "english"
    else
      "simple"
    end

    column = case names
    when String, Symbol
      names.to_s
    when Array
      names.join(", ")
    end
    execute <<-TRIGGER
CREATE TRIGGER #{trigger_name(table, names)}
BEFORE INSERT OR UPDATE
ON #{table}
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(#{vector_search_column_name_for(names)},
                        'pg_catalog.#{dictionary}',
                        #{column});
TRIGGER
  end

  def remove_trigger(table, column)
    execute "DROP TRIGGER IF EXISTS #{trigger_name(table, column)} on #{table};"
  end
end

