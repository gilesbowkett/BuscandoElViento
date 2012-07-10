module VectorMixins
  extend ActiveSupport::Concern


  ####################################################################################
  # Class Methods

  module ClassMethods

    def vector_search(query, columns, language='english')
      where("#{vector_name(columns, language)} @@ #{to_pg_query(query, language)}")
    end

    def order_by_vector(query, columns, language='english')
      order("ts_rank_cd(#{vector_name(columns, language)}, #{to_pg_query(query, language)}) DESC")
    end



    # to_tsquery only accepts single words or words joined by pg query operators (' | ',' & ',' !')
    # Example:
    # to_pg_query("StRing      with and s0me, or stuff . -in not it") #=> "StRing | with & s0me | stuff | in | !it"
    def to_pg_query(query, language)
      pg_syntax = query.gsub(/\W+/, " | ").gsub(/ \| and \| /, " & ").gsub(/ \| or \| /, " | ").gsub(/ \| not \| /, " | !")
      sanitize_sql_array ["to_tsquery('#{language}', ?)", pg_syntax]
    end

    def coalesce_columns(columns)
      columns.map {|s|"coalesce(#{s}, '')"}.join(" || ' ' || ")
    end

    def to_tsvector(columns, language)
      "to_tsvector('#{language}', #{coalesce_columns(columns)})"
    end

    def vector_name(columns, language)
      column_query = case
        when column_exists?(vector_search_column_name_for(columns)) then "#{vector_search_column_name_for(columns)}"
        when column_exists?(column_name_for(columns)) then "#{column_name_for(columns)}"
        else "#{to_tsvector(columns.to_a, language)}"
      end
      column_query
    end

    def column_exists?(column_name)
      column_names.include?(column_name.to_s)
    end

    def column_name_for(args)
      case args
      when String, Symbol
        args.to_sym
      when Array
        args.join("_and_").to_sym
      end
    end

    def vector_search_column_name_for(args)
      "#{column_name_for(args)}_search_vector".to_sym
    end
  end

end