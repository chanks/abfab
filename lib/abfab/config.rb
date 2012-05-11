require 'singleton'

module ABFab
  class Config
    include Singleton

    def define_test(name, &block)
      test = tests[name] ||= Test.new(name)
      test.instance_eval(&block) if block_given?
      test
    end

    def reset!
      @tests = nil
    end

    def tests
      @tests ||= {}
    end
  end
end
