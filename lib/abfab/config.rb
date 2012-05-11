require 'singleton'

module ABFab
  class Config
    include Singleton

    def define_test(name, &block)
      test = tests[name] ||= Test.new(name)
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
      @tests ||= {}
    end
  end
end
