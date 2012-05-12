require 'singleton'

module ABFab
  class Config
    include Singleton

    def define_test(name, &block)
      test = tests[name.to_s] ||= Test.new(name)
      test.instance_eval(&block) if block_given?
      test
    end

    def redis(client = nil)
      if client
        @redis = client
      else
        @redis
      end
    end

    def reset!
      @tests = nil
      @redis = nil
    end

    def tests
      @tests ||= Hash.new { |hash, key| hash[key.to_s] if Symbol === key }
    end
  end
end
