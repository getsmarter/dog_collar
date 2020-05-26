require 'dog_collar/settings'

module DogCollar
  module Configuration
    def configure
      Datadog.configure do |config|
        c = Settings.new(config)
        yield c
        c.use :sidekiq, tag_args: true if Gem.loaded_specs['sidekiq']
      end
    end
  end
end
