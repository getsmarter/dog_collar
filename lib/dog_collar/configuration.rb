require 'dog_collar/settings'

module DogCollar
  module Configuration
    def configure
      Datadog.configure do |config|
        c = Settings.new(config)
        yield c
      end
    end
  end
end
