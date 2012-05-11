require "abfab/config"
require "abfab/test"
require "abfab/version"

module ABFab
  class << self
    def config(&block)
      config = Config.instance
      yield config if block_given?
      config
    end
    alias :configure :config

    Config.public_instance_methods(false).each do |method|
      class_eval <<-METHOD
        def #{method}(*args)
          config.send(:#{method}, *args)
        end
      METHOD
    end
  end
end
