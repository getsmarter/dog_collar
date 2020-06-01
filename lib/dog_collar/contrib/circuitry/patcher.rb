require 'dog_collar/contrib/circuitry/tracing_middleware'

module DogCollar
  module Contrib
    module Circuitry
      module Patcher
        include Datadog::Contrib::Patcher

        module_function

        def target_version
          Integration.version
        end

        def patch
          ::Circuitry.subscriber_config do |c|
            c.logger = Datadog.configuration.logger.instance.clone
            c.middleware.add TracingMiddleware
          end
        end
      end
    end
  end
end