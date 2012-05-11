require 'redis'
require 'abfab'

$redis = Redis.new

RSpec.configure do |config|
  config.before do
    ABFab.reset!
    ABFab.config.redis($redis)
  end
end
