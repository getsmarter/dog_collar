# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dog_collar/version'

Gem::Specification.new do |spec|
  spec.name = 'dog_collar-core'
  spec.version = DogCollar::VERSION::STRING
  spec.required_ruby_version = ">= #{DogCollar::VERSION::MINIMUM_RUBY_VERSION}"
  spec.required_rubygems_version = '>= 2.0.0'
  spec.authors = ['James Behr']
  spec.email = ['jbehr@2u.com']
  spec.summary = 'DogCollar core logging functionality'
  spec.homepage = 'https://github.com/get-smarter/dog_collar'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = `git ls-files -- lib/dog_collar`.split("\n")
  spec.files -= `git ls-files -- lib/dog_collar/contrib`.split("\n")
  spec.test_files = `git ls-files -- spec`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'amazing_print'
  spec.add_dependency 'ddtrace', '~> 0.37.0'
end