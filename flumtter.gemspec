# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flumtter/version'

Gem::Specification.new do |spec|
  spec.name          = "flumtter"
  spec.version       = Flumtter::VERSION
  spec.authors       = ["flum1025"]
  spec.email         = ["flum.1025@gmail.com"]

  spec.summary       = %q{Twitter Client on Terminal}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/flum1025/flumtter4"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = ['flumtter']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'pry', '~> 0.10.4'
  spec.add_dependency 'oauth', '~> 0.5.1'
  spec.add_dependency 'dispel', '~> 0.0.8'
  spec.add_dependency 'terminal-notifier', '~> 1.7.1'
  spec.add_dependency 'twitter', '~> 6.1.0'
  spec.add_dependency 'tmuxinator'
end
