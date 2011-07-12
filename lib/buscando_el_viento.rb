require 'active_record'
require 'active_record/base' # https://github.com/rails/rails/pull/1999

require 'lib/buscando_el_viento/vectors'
require 'lib/buscando_el_viento/triggers'

module BuscandoElViento
  class Migration < ActiveRecord::Migration
    extend Vectors
    extend Triggers
  end
end

