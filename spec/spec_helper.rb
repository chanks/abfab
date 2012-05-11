require 'redis'
require 'abfab'

RSpec.configure do |config|
  config.before do
    ABFab.reset!
  end
end
