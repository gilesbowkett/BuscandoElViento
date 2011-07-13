require File.expand_path("lib/buscando_el_viento")
%w{rubygems active_record}.each {|lib| require lib}

class SearchMigration < BuscandoMigration; end

