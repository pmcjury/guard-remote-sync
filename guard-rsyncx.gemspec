# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "guard/rsyncx/version"

Gem::Specification.new do |s|
  s.name           = "guard-rsyncx"
  s.version        = Guard::RsyncXVersion::VERSION
  s.platform       = Gem::Platform::RUBY
  s.authors        = ["Patrick McJury"]
  s.email          = ["pmcjury@mcjent.com"]
  s.homepage       = "https://github.com/pmcjury/guard-rsyncx"
  s.summary        = "Guard gem for Rsync"
  s.description    = "Guard::RsyncX automatically rsync your files."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "guard-rsynchx"

  s.add_dependency "guard", ">= 1.1.0"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec", ">= 0.9.2.2"
  s.add_development_dependency "guard-rspec"

  s.files = Dir.glob("{lib}/**/*") + %w[LICENSE README.md]
  s.require_path = "lib"
end
