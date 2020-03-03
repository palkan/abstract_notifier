source "https://rubygems.org"

# Specify your gem's dependencies in abstract_notifier.gemspec
gemspec

gem "pry-byebug"

local_gemfile = File.join(__dir__, "Gemfile.local")

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
else
  gem "rails", "~> 6.0"
end
