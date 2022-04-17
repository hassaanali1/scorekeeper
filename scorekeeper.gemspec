# frozen_string_literal: true

require_relative "lib/scorekeeper/version"

Gem::Specification.new do |spec|
  spec.name = "scorekeeper"
  spec.version = Scorekeeper::VERSION
  spec.authors = ["Hassaan Ali"]
  spec.email = ["hassaan1@ualberta.ca"]

  spec.summary = "This gem takes a set up soccer matches as input and displays the scores at the end of each match day."
  spec.homepage = "https://github.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"?
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com"
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("{lib,bin}/**/*")
  spec.bindir = "bin"
  spec.executables = ["scorekeeper"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
