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
      @_logger ||= LoggerSettings.new
    end

    def autoload!
      AUTOLOADS.each do |name|
        integration = registry[name]
        use(name) if !integration.nil? && integration.class.patchable?
      end
    end

    def method_missing(method, *args, &block)
      if @config.respond_to?(method)
        @config.send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      super || @config.respond_to?(method, include_private)
    end
  end
end
