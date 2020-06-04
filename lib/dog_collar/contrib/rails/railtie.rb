module DogCollar
  module Contrib
    module Rails
      class Railtie < ::Rails::Railtie
        # before_configuration
        config.before_configuration do |app|
          logger = Datadog.configuration[:rails].logger.instance
          logger = DogCollar::Contrib::Rails::TaggedLogger.new(logger)
          app.config.lograge.enabled = true

          # Lograge's log formatters do not provide enough control over how
          # the resulting log message is passed to the logger as it only
          # allows the formatting of the message argument. Since we're
          # relying on the DogCollar log formatters to format the log message
          # and metadata we use a delegator to construct an appropriate log
          # message before passing it along to the DogCollar loggers. We also
          # use the raw formatter to ensure the Lograge parameters are passed
          # through as a hash instead of as a string.
          app.config.lograge.logger = Lograge::DelegatingLogger.new(logger)
          app.config.lograge.formatter = ::Lograge::Formatters::Raw.new

          # If the user has set a custom logger, it should be respected
          if app.config.logger.nil?
            # Rails.logger is set from the application config early in the
            # initialization process. Since this code is run in an application
            # initializer, it has to be manually overridden.
            ::Rails.logger = logger
          end
        end
      end
    end
  end
end
