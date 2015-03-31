require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rspec'

require 'guard/remote-sync'
require 'guard/remote-sync/command'
require 'guard/remote-sync/source'
require 'guard/compat/test/helper'
include RSpec::Matchers

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec

  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
    $stderr.stub!(:puts)
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end

  config.after(:each) do
    ENV["GUARD_ENV"] = nil
  end
end
