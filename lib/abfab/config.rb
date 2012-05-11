require 'singleton'

module ABFab
  class Config
    include Singleton

    def define_test(name, &block)
      test = Test.new(name)
      test.instance_eval(&block) if block_given?
      tests << test
      test
    end

    def tests
      @tests ||= []
    end
  end
end
