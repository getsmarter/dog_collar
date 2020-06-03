module DogCollar
  module Contrib
    module Rails
      module Configuration
        class Settings < Datadog::Contrib::Rails::Configuration::Settings
          settings :logger do
            option :instance do |o|
              o.default do
                service_name = Datadog.configuration[:rails].service_name

                # TODO: Override log device, formatter and level
                DogCollar::Contrib::Rails::Logger.new(STDOUT, service: service_name)
              end
              o.lazy
            end
          end

          option :service_name do |o|
            o.default { Datadog.configuration.service }
            o.lazy
          end
        end
      end
    end
  end
end
