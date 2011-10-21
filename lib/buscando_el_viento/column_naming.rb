module BuscandoElViento
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
