require 'disjoined_intervals'

require 'rspec'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc in
# spec/support/ and its subdirectories.
Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
