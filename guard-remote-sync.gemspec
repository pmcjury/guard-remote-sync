# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "guard/remote-sync/version"

Gem::Specification.new do |s|
  s.name           = "guard-remote-sync"
  s.version        = Guard::RemoteSyncVersion::VERSION
  s.platform       = Gem::Platform::RUBY
  s.authors        = ["Patrick McJury"]
  s.email          = ["pmcjury@mcjent.com"]
  s.homepage       = "https://github.com/pmcjury/guard-remote-sync"
  s.summary        = "Guard gem for Remote Syncing through rsync"
  s.description    = "Guard::RemoteSync to automatically rsync your files."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "guard-remote-synch"

  s.add_dependency "guard", ">= 1.1.0"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec", ">= 0.9.2.2"
  s.add_development_dependency "guard-rspec"

  s.files = Dir.glob("{lib}/**/*") + %w[LICENSE README.md]
  s.require_path = "lib"
end
