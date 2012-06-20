# -*- encoding: utf-8 -*-
require File.expand_path("../lib/noodall/form_builder/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "noodall-form-builder"
  s.version     = Noodall::FormBuilder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve England", "Daniel Craig", "Alex Heaton", "Jordan Elver"]
  s.email       = ["info@wearebeef.co.uk"]
  s.homepage    = "http://rubygems.org/gems/noodall-form-builder"
  s.summary     = "Noodall Form Builder"
  s.description = "Functionality for building custom forms"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_dependency 'fastercsv', ">= 0"
  s.add_dependency 'defensio', ">= 0.9.1"
  s.add_dependency 'rakismet', ">= 1.2.1"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
