# frozen_string_literal: true

require_relative 'lib/mwiki/version'

Gem::Specification.new do |spec|
  spec.name          = 'mwiki'
  spec.version       = Mwiki::VERSION
  spec.authors       = %w[shoma07]
  spec.email         = %w[23730734+shoma07@users.noreply.github.com]

  spec.summary       = 'media wiki search command line tool'
  spec.description   = 'media wiki search command line tool'
  spec.homepage      = 'https://github.com/shoma07/mwiki'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
end
