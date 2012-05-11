# -*- encoding: utf-8 -*-
require File.expand_path('../lib/abfab/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Hanks"]
  gem.email         = ["christopher.m.hanks@gmail.com"]
  gem.description   = %q{A/B testing with Redis.}
  gem.summary       = %q{Fabulous A/B testing with persistence to Redis.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "abfab"
  gem.require_paths = ["lib"]
  gem.version       = ABFab::VERSION

  gem.add_dependency "redis", "~> 2.2.2"

  gem.add_development_dependency "rspec", "~> 2.10.0"
end
