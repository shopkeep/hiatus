$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fakeredis'
require 'rspec'
require 'hiatus'

RSpec.configure do |config|
  config.before { Redis.new.flushdb }
end
