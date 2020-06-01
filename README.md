# DogCollar

## Install
Add this line to your application's Gemfile.

```ruby
gem 'dog_collar', git: 'https://github.com/getsmarter/dog_collar'
```

## Configuration
Example config, for example in a Rails application you might find this inside
`config/initializers/dog_collar.rb`.

```ruby
DogCollar.configure do |config|
  config.service = ENV['APP_NAME'] # Required. Sets the base name for the application.
  config.env = Rails.env

  # Autoload the integrations for DogCollar. Must be called after the service
  # name is set.
  config.autoload!
end
```

## Add Datadog to your project
```ruby
Datadog.configure do |c|
  c.analytics_enabled = true
  c.tracer tags: { 'env' => ENV['RAILS_ENV'] }, debug: debug
end
```

# Rails specific setup

```ruby
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = GroundControl::Lograge::Formatter.new
  config.log_level = :info
  config.logger = GroundControl::Logger.new(STDOUT)
end
```
