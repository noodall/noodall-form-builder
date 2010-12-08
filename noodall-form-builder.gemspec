# -*- encoding: utf-8 -*-
require File.expand_path("../lib/noodall/form_builder/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "noodall-form-builder"
  s.version     = Noodall::FormBuilder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/noodall-form-builder"
  s.summary     = "Noodall Form Builder"
  s.description = "Functionality for building custom forms"

  s.required_rubygems_version = ">= 1.3.6"
#  s.rubyforge_project         = "noodall-form-builder"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_dependency 'fastercsv', ">= 0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
