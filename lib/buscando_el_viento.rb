require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999
require 'active_support/concern'

require File.dirname(__FILE__) + '/buscando_el_viento/vectors'
require File.dirname(__FILE__) + '/buscando_el_viento/triggers'
require File.dirname(__FILE__) + '/buscando_el_viento/indexes'
require File.dirname(__FILE__) + '/buscando_el_viento/search'
require File.dirname(__FILE__) + '/buscando_el_viento/column_naming'
require File.dirname(__FILE__) + '/buscando_el_viento/vector_mixins'

class BuscandoMigration < ActiveRecord::Migration
  include BuscandoElViento
end

