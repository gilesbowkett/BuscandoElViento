require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

module BuscandoElViento
  class Migration < ActiveRecord::Migration

    def self.add_search_vector(table, column)
      add_column(table, "#{column}_search_vector".to_sym, "tsvector")
    end
    def self.remove_search_vector(table, column)
      remove_column(table, "#{column}_search_vector".to_sym)
    end

  end
end

