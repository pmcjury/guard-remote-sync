# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/rsynchx/version'

Gem::Specification.new do |s|
  s.name           = "guard-rsynch-extended"
  s.version        = Guard::RsynchX::VERSION
  s.platform       = Gem::Platform::RUBY
  s.authors        = ["Patrick McJury"]
  s.email          = ["pmcjury@mcjent.com"]
  s.homepage       = ''
  s.summary        = 'Guard gem for Rsynch'
  s.description    = 'Guard::RsynchX automatically rsynch your files.'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = ''

  s.add_dependency 'guard', '>= 1.1.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'

  s.files = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
end
