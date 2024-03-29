require 'abfab/config'
require 'abfab/helpers'
require 'abfab/possibility'
require 'abfab/test'
require 'abfab/version'

module ABFab
  class << self
    def config(&block)
      config = Config.instance
      config.instance_eval(&block) if block
      config
    end
    alias :configure :config

    Config.public_instance_methods(false).each do |method|
      class_eval "def #{method}(*args); config.send(:#{method}, *args); end"
    end
  end
end

if defined? Rails::Railtie
  require 'abfab/rails_id'
  require 'abfab/railtie'
end
