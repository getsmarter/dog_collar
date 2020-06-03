module DogCollar
  module Contrib
    module Rails
      module Configuration
        class Settings < Datadog::Contrib::Rails::Configuration::Settings
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
                config = DogCollar.configuration[:rails]

                DogCollar::Contrib::Rails::Logger.new(config.logger.device).tap do |logger|
                  logger.service = config.service_name
                  logger.level = config.logger.level
                  logger.formatter = config.logger.formatter
                end
              end

              o.lazy
            end
          end

          option :service_name do |o|
            o.default { DogCollar.configuration.service }
            o.lazy
          end
        end
      end
    end
  end
end
