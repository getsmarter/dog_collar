# frozen_string_literal: true

source 'https://rubygems.org'

gemspec name: 'dog_collar'

Dir['dog_collar-*.gemspec'].each do |gemspec|
  gemspec name: File.basename(gemspec, '.gemspec')
end

group :development, :test do
  gem 'getsmarter-rubocop-style', git: 'https://github.com/getsmarter/getsmarter-rubocop-style'
end

group :test do
  gem 'simplecov', '~> 0.17.1', require: false
end
