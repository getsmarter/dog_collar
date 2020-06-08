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
  config.version = ENV['APP_VERSION'] # Optional. Could be the SHA1 hash of the Git commit.
  config.env = Rails.env # Optional. Link the environment to the Rails environment

  # Pretty logs in development
  config.logger.formatter = DogCollar::Logging::Formatters::Pretty.new if Rails.env.development?

  # Autoload the integrations for DogCollar. Must be called after the service
  # name is set.
  config.autoload!
end
```

## Logging
DogCollar provides a custom logger, which is largely compatible with the
default Ruby logger API, except it is configured to allow structured logging.

Much like the default Ruby logger, you have access to the methods `debug`,
`info`, `warn`, `error` and `fatal`, which log at the appropriate severity.

```ruby
logger.info "Something"         # Log a message
logger.debug { "Something" }    # Log the result of a block (for expensive to build messages)
```

You can also pass tags to the logger. Tags are key-value pairs of metadata that
are attached to logs. These tags are then forwarded to Datadog.

```ruby
logger.info "Something", foo: "bar"    # Log a message with a tag
logger.info do |meta|                  # Use a block to add tags and a message
  meta[:foo] = "bar"
  "Something"
end
logger.info "Something" do |meta|      # The message argument takes preference over the block return value.
  meta[:foo] = "bar"
end
```

The logger also allows a custom log formatter, which is any callable. This
looks like almost like a conventional Ruby log formatter, except it takes a
severity as an integer instead of a string and receives an additional argument
containing the metadata.

```ruby
labels = %w(debug info warn error fatal)
logger.formatter = proc do |severity, time, progname, msg, meta|
  # Note that severity is an integer, as per Logger::Severity instead of a string
  { severity: labels[severity], time: time.iso8601, progname: progname, msg: msg, **meta }.to_json
end
```

DogCollar currently provides two formatters.

```ruby
DogCollar::Logging::Formatters::JSON     # Default. Logs Datadog compatible JSON, one hash per line.
DogCollar::Logging::Formatters::Pretty   # A pretty logger for use in development
```
