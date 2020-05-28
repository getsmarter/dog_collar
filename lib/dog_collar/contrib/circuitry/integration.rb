require 'ddtrace'
require 'dog_collar/contrib/circuitry/patcher'
require 'dog_collar/contrib/circuitry/configuration/settings'

module DogCollar
  module Contrib
    module Circuitry
      class Integration
        include Datadog::Contrib::Integration

        MINIMUM_VERSION = Gem::Version.new('3.2.0')

        register_as :circuitry

        def self.version
          Gem.loaded_specs['circuitry'] && Gem.loaded_specs['circuitry'].version
        end

        def self.loaded?
          !defined?(::Circuitry).nil?
        end

        def self.compatible?
          super && version >= MINIMUM_VERSION
        end

        def default_configuration
          Configuration::Settings.new
        end

        def patcher
          Patcher
        end
      end
    end
  end
end
