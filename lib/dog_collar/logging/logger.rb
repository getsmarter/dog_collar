require 'dog_collar/logging/formatters/json'
require 'dog_collar/logging/formatters/pretty'
require 'dog_collar/logging/hooks'

module DogCollar
  module Logging
    class Logger < Logger
      include Hooks

      LOG_SEV = {
        debug: Logger::DEBUG,
        info: Logger::INFO,
        warn: Logger::WARN,
        error: Logger::ERROR,
        fatal: Logger::FATAL
      }

      attr_accessor :formatter

      def initialize(*, **)
        super
        @formatter = default_formatter if @formatter.nil?
      end

      # def before_log(&block)
      #   self.class.before_log(&block)
      # end

      LOG_SEV.each do |method_name, severity|
        define_method(method_name) do |message = nil, **meta|
          add(severity, message, **meta)
        end
      end

      def add(severity, message = nil, **meta)
        severity ||= ::Logger::UNKNOWN
        write(severity, message, meta)
      end

      private

      def write(severity, message, meta)
        @logdev.write(format_message(severity, Time.now, progname, message, meta))
        true
      end

      def default_formatter
        Formatters::JSON.new
      end

      def format_message(severity, datetime, progname, msg, meta)
        (@formatter || @default_formatter).call(severity, datetime, progname, msg, meta)
      end
    end
  end
end
