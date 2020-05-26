module DogCollar
  class Settings
    attr_accessor :service_name

    def initialize(config)
      @config = config
    end

    def instrument(integration_name, **options, &block)
      options[:service_name] ||= "#{service_name}-#{integration_name}"
      @config.use integration_name, **options, &block
    end

    def method_missing(method, *args, &block)
      @config.send(method, *args, &block)
    end

    alias_method :use, :instrument
  end
end
