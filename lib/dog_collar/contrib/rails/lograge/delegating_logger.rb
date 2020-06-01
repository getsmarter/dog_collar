module DogCollar
  module Contrib
    module Rails
      module Lograge
        class DelegatingLogger
          attr_accessor :logger

          def initialize(logger)
            @logger = logger
          end

          %i{debug info warn error fatal}.each do |method_name|
            define_method(method_name) do |data|
              logger.send(method_name, build_message(data), data)
            end
          end

          def method_missing(method, *args)
            logger.send(method, *args)
          end

          private

          def build_message(method:, path:, status:, controller:, action:, format:, **)
            "#{method} #{path} (#{status}) -> #{controller}##{action}.#{format}"
          end

          def formatter
            Datadog.configuration.logger.instance.formatter
          end
        end
      end
    end
  end
end
