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
Add the following to your gemfile

NOTE: Ensure `ddtrace` is at least v0.33.0, otherwise the `tag_args` option on
the Sidekiq instrumentation will not work.

```ruby
# Gemfile
gem `ddtrace`
```

Datadog setup

```ruby
Datadog.configure do |c|
  app_name = ENV['APP_NAME']

  c.use :rails, service_name: app_name
  c.use :sequel, service_name: "#{app_name}-sequel"
  c.use :ethon, service_name: "#{app_name}-typhoeus", split_by_domain: true
  c.use :sidekiq, service_name: "#{app_name}-sidekiq",
    client_service_name: "#{app_name}-sidekiq-client",
    tag_args: true

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

# Circuitry
```ruby
Circuitry.subscriber_config do |c|
  c.queue_name = "ground-control-#{Rails.env}"
  c.access_key = ENV['GSMQ_AWS_ACCESS_KEY']
  c.secret_key = ENV['GSMQ_AWS_SECRET_KEY']
  c.region = ENV['GSMQ_AWS_REGION']
end

Circuitry.subscriber_config do |c|
  c.logger = Rails.logger
  c.middleware.add GroundControl::Circuitry::TracingMiddleware, service_name: "#{ENV['APP_NAME']}-circuitry"
end
```
