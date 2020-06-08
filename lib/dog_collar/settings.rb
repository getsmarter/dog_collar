# frozen_string_literal: true

module DogCollar
  class Settings
    AUTOLOADS = %i[sidekiq rails circuitry ethon sequel active_record].freeze

    class LoggerSettings
      attr_accessor :device, :level, :formatter

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
        use(name) if integration.class.patchable?
      end
    end

    def method_missing(method, *args, &block)
      @config.send(method, *args, &block)
    end
  end
end
