module BuscandoElViento
  module Triggers
    include BuscandoElViento::Vectors
    # FIXME: I'm including this module because it enables trigger_name to use
    #        vector_name. however, it's lame to include the module twice, and
    #        the main file also includes it. so I think I'll keep the distinct
    #        files but do away with the whole modules thingamabob.

    def trigger_name(table, column)
      "#{table}_#{vector_name(column)}_update"
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

