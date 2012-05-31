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
end
