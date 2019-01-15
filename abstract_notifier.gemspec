# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "abstract_notifier/version"

Gem::Specification.new do |spec|
  spec.name          = "abstract_notifier"
  spec.version       = AbstractNotifier::VERSION
  spec.authors       = ["Vladimir Dementyev"]
  spec.email         = ["dementiev.vm@gmail.com"]

  spec.summary       = "ActionMailer-like interface for any type of notifications"
  spec.description   = "ActionMailer-like interface for any type of notifications"
  spec.homepage      = "https://github.com/palkan/abstract_notifier"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.4"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "active_delivery"

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "standard", "~> 0.0.12"
end
