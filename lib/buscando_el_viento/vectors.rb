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
end

