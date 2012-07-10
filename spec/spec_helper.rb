$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
%w{rubygems buscando_el_viento}.each {|lib| require lib}


class SearchMigration
  include BuscandoElViento
end
