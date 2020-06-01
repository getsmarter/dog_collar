require 'ddtrace'
require 'dog_collar/contrib/ethon/configuration/settings'

module DogCollar
  module Contrib
    module Ethon
      class Integration < Datadog::Contrib::Ethon::Integration
        register_as :ethon

        def default_configuration
          Configuration::Settings.new
        end
      end
    end
  end
end
