module DogCollar
  module Contrib
    module Rails
      module Configuration
        class Settings < Datadog::Contrib::Rails::Configuration::Settings
          option :service_name do |o|
            o.default { Datadog.configuration.service }
            o.lazy
          end
        end
      end
    end
  end
end
