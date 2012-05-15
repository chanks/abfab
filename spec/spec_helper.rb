require 'redis'
require 'abfab'

# Require shared example groups before running any specs
Dir["#{File.dirname(__FILE__)}/**/shared/*.rb"].each { |file| require file }

require 'logger'

$redis = Redis.new :logger => Logger.new(STDOUT)

RSpec.configure do |config|
  config.before do
    $redis.flushdb
    ABFab.reset!
    ABFab.config.redis($redis)
  end
end

def create_test_results(test_name, results = {})
  puts $redis.info

  test = ABFab.tests[test_name]
  user = 0

  results.each do |value, (participated, converted)|
    possibility  = test.possibilities[value]
    participants = (1..participated).map { user += 1 }
    conversions  = participants.sample(converted)

    $redis.sadd possibility.key_for(:participants), participants
    $redis.sadd possibility.key_for(:conversions),  conversions
  end
end
