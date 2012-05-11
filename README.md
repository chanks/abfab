# AB Fab

AB Fab is a gem for A/B testing with persistence to Redis.

Currently, it is NOT Fab, and should not be used by anyone for any reason.

## Goals
* Easy to use.
* Fast.
* Simple - no dependencies aside from Redis and the `redis` gem.
* Durable - apps shouldn't go down if the Redis connection is lost.

## TODO
* Automatic Rails integration.
* Different value selection modes for development, test, production.
* Add some way for the app to ignore bots and uptime pings and whatnot, so as not to mess with the statistics.
* Automatically stop testing and only show one result when it's shown to be the best. (?)
* Rake task to clean out results from retired tests (will need $redis.keys then a mass $redis.del).
* Rake task to view test results.
  * Don't show results for tests that are still in progress (haven't reached the significance mark). Maybe let the user specify a flag to force their display.
  * For tests still in progress, show many data points have been accumulated and how many are necessary.

## Installation

Add this line to your application's Gemfile:

    gem 'abfab'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abfab

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
