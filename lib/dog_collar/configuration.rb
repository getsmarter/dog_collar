require 'dog_collar/settings'

module DogCollar
  module Configuration
    attr_writer :configuration

    def configuration
      @configuration ||= Settings.new(Datadog.configuration)
    end

    def configure
      Datadog.configure do |config|
        yield configuration
      end
    end
  end
end
