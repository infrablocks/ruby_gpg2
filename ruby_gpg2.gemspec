# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_gpg2/version'

files = %w[
  bin
  lib
  CODE_OF_CONDUCT.md
  ruby_gpg2.gemspec
  Gemfile
  LICENSE.txt
  Rakefile
  README.md
]

Gem::Specification.new do |spec|
  spec.name = 'ruby_gpg2'
  spec.version = RubyGPG2::VERSION
  spec.authors = ['InfraBlocks Maintainers']
  spec.email = ['maintainers@infrablocks.io']

  spec.summary = 'A simple Ruby wrapper for invoking gpg (>= 2.0) commands.'
  spec.description = 'Wraps the gpg binary (>= 2.0) so that it can be ' \
                     'invoked from a Ruby script or Rakefile.'
  spec.homepage = 'https://github.com/infrablocks/ruby_gpg2'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(/^(#{files.map { |g| Regexp.escape(g) }.join('|')})/)
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency 'lino', '>= 3.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake_circle_ci'
  spec.add_development_dependency 'rake_git'
  spec.add_development_dependency 'rake_git_crypt'
  spec.add_development_dependency 'rake_github'
  spec.add_development_dependency 'rake_gpg'
  spec.add_development_dependency 'rake_ssh'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'

  spec.metadata['rubygems_mfa_required'] = 'false'
end
