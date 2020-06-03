module DogCollar
  class Settings
    AUTOLOADS = %i(sidekiq rails circuitry ethon sequel active_record)

    class LoggerSettings
      attr_reader :device, :level, :formatter

      def initialize
        @device = STDOUT
        @level = :info
        @formatter = DogCollar::Logging::Formatters::JSON.new
      end
    end

    def initialize(config)
      @config = config
    end

    def logger
      @logger ||= LoggerSettings.new
    end

    def autoload!
      AUTOLOADS.each do |name|
        integration = registry[name]
        if integration.class.patchable?
          use(name)
        end
      end
    end

    def method_missing(method, *args, &block)
      @config.send(method, *args, &block)
    end
  end
end
