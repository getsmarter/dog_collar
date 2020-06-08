# frozen_string_literal: true

module DogCollar
  module Contrib
    module Circuitry
      module Configuration
        class Settings < Datadog::Contrib::Configuration::Settings
          settings :logger do
            option :formatter do |o|
              o.default { DogCollar.configuration.logger.formatter }
              o.lazy
            end

            option :device do |o|
              o.default { DogCollar.configuration.logger.device }
              o.lazy
            end

            option :level do |o|
              o.default { DogCollar.configuration.logger.level }
              o.lazy
            end

            option :instance do |o|
              o.default do
                config = DogCollar.configuration[:circuitry]

                DogCollar::Logging::InstrumentedLogger.new(config.logger.device).tap do |logger|
                  logger.service = config.service_name
                  logger.level = config.logger.level
                  logger.formatter = config.logger.formatter
                end
              end

              o.lazy
            end
          end

          option :service_name do |o|
            o.default { "#{Datadog.configuration.service}-circuitry" }
            o.lazy
          end
        end
      end
    end
  end
end
