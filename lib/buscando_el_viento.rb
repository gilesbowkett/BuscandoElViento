require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

require 'lib/buscando_el_viento/vectors'
require 'lib/buscando_el_viento/triggers'

class BuscandoMigration < ActiveRecord::Migration
  extend BuscandoElViento
end

