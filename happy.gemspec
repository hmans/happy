# -*- encoding: utf-8 -*-
require File.expand_path('../lib/happy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Hendrik Mans"]
  gem.email         = ["hendrik@mans.de"]
  gem.description   = %q{A happy little toolkit for writing web applications.}
  gem.summary       = %q{A happy little toolkit for writing web applications.}
  gem.homepage      = "https://github.com/hmans/happy"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "happy"
  gem.require_paths = ["lib"]
  gem.version       = Happy::VERSION

  gem.add_dependency 'activesupport', '~> 3.1'
  gem.add_dependency 'rack', '~> 1.4'
  gem.add_dependency 'happy-helpers' # TODO: , '~> 0.1.0'
  gem.add_dependency 'allowance', '>= 0.1.1'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.8'
  gem.add_development_dependency 'rspec-html-matchers'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'watchr'
end
