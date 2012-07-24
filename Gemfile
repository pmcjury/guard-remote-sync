source "http://rubygems.org"

gemspec

gem "rake"
gem "rspec"       # for rspec-core, rspec-expectations, rspec-mocks
gem "rspec-mocks" # for rspec-mocks only

platform :ruby do
  gem "rb-readline"
end

require "rbconfig"

if RbConfig::CONFIG["target_os"] =~ /darwin/i
  gem "ruby_gntp", :require => false
elsif RbConfig::CONFIG["target_os"] =~ /linux/i
  gem "libnotify", :require => false
elsif RbConfig::CONFIG["target_os"] =~ /mswin|mingw/i
  gem "win32console", :require => false
  gem "rb-notifu", :require => false
end