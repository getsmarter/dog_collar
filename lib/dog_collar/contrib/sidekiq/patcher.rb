require 'dog_collar/contrib/sidekiq/server_tracer'

module DogCollar
  module Contrib
    module Sidekiq
      module Patcher
        include Datadog::Contrib::Sidekiq::Patcher

        module_function

        def patch
          Datadog::Contrib::Sidekiq::Patcher.patch
          ::Sidekiq.configure_server do |config|
            config.server_middleware do |chain|
              chain.insert_after Datadog::Contrib::Sidekiq::ServerTracer, ServerTracer
            end

            config.logger.level = Logger::ERROR
          end

          # config.error_handlers.reject! { |handler| handler.is_a?(Sidekiq::ExceptionHandler::Logger) }
          # config.error_handlers << GroundControl::Sidekiq::ErrorHandler.new
        end
      end
    end
  end
end
