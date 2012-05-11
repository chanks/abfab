require 'redis'
require 'abfab'

# Require shared example groups before running any specs
Dir["#{File.dirname(__FILE__)}/**/shared/*.rb"].each { |file| require file }

$redis = Redis.new

RSpec.configure do |config|
  config.before do
    ABFab.reset!
    ABFab.config.redis($redis)
  end
end
