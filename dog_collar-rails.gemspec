# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dog_collar/version'

extension_files = []
Dir['dog_collar-*.gemspec'].each do |gemspec|
  next if gemspec == __FILE__

  name = File.basename(gemspec, '.gemspec').gsub('dog_collar-', '')
  extension_files << "lib/dog_collar/#{name}.rb"

  Dir["lib/dog_collar/contrib/#{name}/**/*.rb"].each do |file|
    extension_files << file
  end
end

Gem::Specification.new do |spec|
  spec.name = 'dog_collar-rails'
  spec.version = DogCollar::VERSION::STRING
  spec.required_ruby_version = ">= #{DogCollar::VERSION::MINIMUM_RUBY_VERSION}"
  spec.required_rubygems_version = '>= 2.0.0'
  spec.authors = ['James Behr']
  spec.email = ['jbehr@2u.com']
  spec.summary = 'DogCollar Rails instrumentation'
  spec.homepage = 'https://github.com/get-smarter/dog_collar'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -- lib/dog_collar/contrib/rails`.split("\n")
  spec.files -= extension_files
  spec.test_files = `git ls-files -- spec`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'dog_collar-core', DogCollar::VERSION::STRING
  spec.add_dependency 'lograge'
end
