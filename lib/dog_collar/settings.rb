module DogCollar
  class Settings
    AUTOLOADS = [:sidekiq, :rails, :circuitry, :ethon, :sequel, :activerecord]

    def initialize(config)
      @config = config
    end

    def method_missing(method, *args, &block)
      @config.send(method, *args, &block)
    end

    def autoload!
      AUTOLOADS.map do |integration|
        use integration if Gem.loaded_specs[integration.to_s]
      end
    end
  end
end
