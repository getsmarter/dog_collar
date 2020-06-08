# frozen_string_literal: true

require 'dog_collar/settings'

module DogCollar
  module Configuration
    attr_writer :configuration

    def configuration
      @_configuration ||= Settings.new(Datadog.configuration)
    end

    def configure
      Datadog.configure do |_config|
        yield configuration
      end
    end
  end
end
