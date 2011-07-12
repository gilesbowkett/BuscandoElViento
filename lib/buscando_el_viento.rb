require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

require 'lib/buscando_el_viento/vectors'
require 'lib/buscando_el_viento/triggers'
require 'lib/buscando_el_viento/indexes'
require 'lib/buscando_el_viento/search'

class BuscandoMigration < ActiveRecord::Migration
  extend BuscandoElViento
end

