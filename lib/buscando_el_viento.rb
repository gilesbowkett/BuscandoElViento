require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

module BuscandoElViento
  class Migration < ActiveRecord::Migration

    def self.vector_name(column)
      "#{column}_search_vector".to_sym
    end
    def self.add_search_vector(table, column)
      add_column(table, vector_name(column), "tsvector")
    end
    def self.remove_search_vector(table, column)
      remove_column(table, vector_name(column))
    end

    def self.add_trigger(table, column)
      execute <<TRIGGER
CREATE TRIGGER #{table}_#{column}_search_vector_update
BEFORE INSERT OR UPDATE
ON #{table}
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(#{column}_search_vector,
                        'pg_catalog.english',
                        #{column});
TRIGGER
    end
    def self.remove_trigger(table, column)
      execute "DROP TRIGGER IF EXISTS #{table}_#{column}_search_vector_update on #{table};"
    end

  end
end

