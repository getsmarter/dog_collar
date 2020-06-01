module DogCollar
  module Contrib
    module Rails
      module Patcher
        include Datadog::Contrib::Rails::Patcher

        module_function

        def patch
          Datadog::Contrib::Rails::Patcher.patch
          require 'lograge'

          logger = Datadog.configuration.logger.instance

          ::Rails.application.configure do
            config.logger = logger.clone

            # Lograge's log formatters do not provide enough control over how
            # the resulting log message is passed to the logger as it only
            # allows the formatting of the message argument. Since we're
            # relying on the DogCollar log formatters to format the log message
            # and metadata we use a delegator to construct an appropriate log
            # message before passing it along to the DogCollar loggers. We also
            # use the raw formatter to ensure the Lograge parameters are passed
            # through as a hash instead of as a string.
            config.lograge.enabled = true
            config.lograge.logger = Lograge::DelegatingLogger.new(logger.clone)
            config.lograge.formatter = ::Lograge::Formatters::Raw.new
          end
        end
      end
    end
  end
end
