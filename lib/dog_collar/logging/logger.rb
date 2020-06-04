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

      LOG_SEV.each do |method_name, severity|
        define_method(method_name) do |message = nil, **meta, &block|
          add(severity, message, **meta, &block)
        end

        # Allow severity checks to work even when level is overriden in older
        # versions of Ruby (< 2.7.0).
        define_method("#{method_name}?") do
          level <= severity
        end
      end

      def with(**meta)
        child = clone
        child.before_log { meta }
        child
      end

      def add(severity, message = nil, **meta, &block)
        severity ||= ::Logger::UNKNOWN
        return true if @logdev.nil? || severity < level

        if block_given?
          if message.nil?
            message = yield meta
          else
            yield meta
          end
        end

        @logdev.write(format_message(severity, Time.now, progname, message, meta))
        true
      end

      alias log add

      private

      def default_formatter
        Formatters::JSON.new
      end

      def format_message(severity, datetime, progname, msg, meta)
        (@formatter || @default_formatter).call(severity, datetime, progname, msg, meta)
      end
    end
  end
end
