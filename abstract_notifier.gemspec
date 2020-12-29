# frozen_string_literal: true

require_relative "lib/abstract_notifier/version"

Gem::Specification.new do |spec|
  spec.name = "abstract_notifier"
  spec.version = AbstractNotifier::VERSION
  spec.authors = ["Vladimir Dementyev"]
  spec.email = ["dementiev.vm@gmail.com"]

  spec.summary = "ActionMailer-like interface for any type of notifications"
  spec.description = "ActionMailer-like interface for any type of notifications"
  spec.homepage = "https://github.com/palkan/abstract_notifier"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.4"

  spec.metadata = {
    "bug_tracker_uri" => "http://github.com/palkan/abstract_notifier/issues",
    "changelog_uri" => "https://github.com/palkan/abstract_notifier/blob/master/CHANGELOG.md",
    "documentation_uri" => "http://github.com/palkan/abstract_notifier",
    "homepage_uri" => "http://github.com/palkan/abstract_notifier",
    "source_code_uri" => "http://github.com/palkan/abstract_notifier"
  }

  spec.files = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "active_delivery"

  spec.add_development_dependency "bundler", ">= 1.16"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "rspec-rails", ">= 4.0"
end
