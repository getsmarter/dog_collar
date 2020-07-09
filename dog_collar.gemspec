# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dog_collar/version'

Gem::Specification.new do |spec|
  spec.name                  = 'dog_collar'
  spec.version               = DogCollar::VERSION::STRING
  spec.required_ruby_version = ">= #{DogCollar::VERSION::MINIMUM_RUBY_VERSION}"
  spec.required_rubygems_version = '>= 2.0.0'
  spec.authors               = ['James Behr']
  spec.email                 = ['jbehr@2u.com']

  spec.summary     = 'Datadog wrapper'
  spec.description = <<-DESCRIPTION.gsub(/^[\s]+/, '')
    Wrapper around ddtrace
  DESCRIPTION

  spec.homepage = 'https://github.com/get-smarter/dog_collar'

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  # Optional extensions
  spec.add_dependency 'amazing_print'
  spec.add_dependency 'ddtrace', '~> 0.37.0'
  spec.add_dependency 'lograge'

  # Development dependencies
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'aws-sdk', '~> 3'
  spec.add_development_dependency 'circuitry', '~> 3.3.0'
  spec.add_development_dependency 'rake', '>= 10.5'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sidekiq'
end
