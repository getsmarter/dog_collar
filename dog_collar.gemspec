# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dog_collar/version'

Gem::Specification.new do |spec|
  spec.name = 'dog_collar'
  spec.version = DogCollar::VERSION::STRING
  spec.required_ruby_version = ">= #{DogCollar::VERSION::MINIMUM_RUBY_VERSION}"
  spec.required_rubygems_version = '>= 2.0.0'
  spec.authors = ['James Behr']
  spec.email = ['jbehr@2u.com']

  spec.summary = 'Zero-configuration structured logging and instrumentation'
  spec.description = <<-DESCRIPTION.gsub(/^[\s]+/, '')
    DogCollar wraps ddtrace-rb with sensible defaults for instrumentation, as
    well as including a structured logger that automatically relates logs to
    the active trace.
  DESCRIPTION

  spec.homepage = 'https://github.com/get-smarter/dog_collar'

  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files = ['lib/dog_collar.rb']
  spec.require_paths = ['lib']

  Dir['dog_collar-*.gemspec'].each do |gemspec|
    extension = File.basename(gemspec, '.gemspec')
    spec.add_dependency extension, DogCollar::VERSION::STRING
  end

  # Development dependencies
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'aws-sdk', '~> 3'
  spec.add_development_dependency 'circuitry', '~> 3.3.0'
  spec.add_development_dependency 'rake', '>= 10.5'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sidekiq'
end
