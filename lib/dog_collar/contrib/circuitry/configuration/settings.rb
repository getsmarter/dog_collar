module DogCollar
  module Contrib
    module Circuitry
      module Configuration
        class Settings < Datadog::Contrib::Configuration::Settings
          option :service_name do |o|
            o.default { "#{Datadog.configuration.service}-circuitry" }
            o.lazy
          end
        end
      end
    end
  end
end