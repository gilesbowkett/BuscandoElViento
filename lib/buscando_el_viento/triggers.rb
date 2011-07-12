module BuscandoElViento
  module Triggers
    def trigger_name(table, column)
      "#{table}_#{column}_search_vector_update"
    end
    def add_trigger(table, column)
      execute <<TRIGGER
CREATE TRIGGER #{trigger_name(table, column)}
BEFORE INSERT OR UPDATE
ON #{table}
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(#{vector_name(column).to_s},
                        'pg_catalog.english',
                        #{column});
TRIGGER
    end
    def remove_trigger(table, column)
      execute "DROP TRIGGER IF EXISTS #{trigger_name(table, column)} on #{table};"
    end
  end
end

