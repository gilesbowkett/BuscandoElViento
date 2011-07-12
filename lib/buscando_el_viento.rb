require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

module BuscandoElViento

  module Vectors
    def vector_name(column)
      "#{column}_search_vector".to_sym
    end
    def add_search_vector(table, column)
      add_column(table, vector_name(column), "tsvector")
    end
    def remove_search_vector(table, column)
      remove_column(table, vector_name(column))
    end
  end

  module Triggers
    # FIXME: it may be worthwhile to separate these concerns, and their specs, into
    # distinct sub-modules
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
  class Migration < ActiveRecord::Migration
    extend Vectors
    extend Triggers
  end
end

