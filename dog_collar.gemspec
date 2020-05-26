# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
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
  spec.description = <<-EOS.gsub(/^[\s]+/, '')
    Wrapper around ddtrace
  EOS

  spec.homepage = 'https://github.com/get-smarter/dog_collar'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  # Optional extensions
  spec.add_development_dependency 'ddtrace', '>= 0.4.1'
  spec.add_development_dependency 'sidekiq'

  # Development dependencies
  spec.add_development_dependency 'rake', '>= 10.5'
  spec.add_development_dependency 'rubocop', '= 0.49.1' if RUBY_VERSION >= '2.1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
