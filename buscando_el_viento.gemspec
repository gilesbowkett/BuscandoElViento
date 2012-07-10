# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "buscando_el_viento/version"

Gem::Specification.new do |s|
  s.name        = "buscando_el_viento"
  s.version     = BuscandoElViento::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["giles bowkett", "xavier shay"]
  s.email       = ["gilesb@gmail.com"]
  s.homepage    = "https://github.com/gilesbowkett/buscando_el_viento"
  s.summary = s.description = %q{Rails migration class methods for PostgreSQL search}

  s.rubyforge_project = "buscando_el_viento"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency 'activerecord', '>= 3.1'
  s.add_dependency 'activesupport', '>= 3.1'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end

