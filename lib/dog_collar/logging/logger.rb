require 'dog_collar/logging/formatters/json'
require 'dog_collar/logging/formatters/pretty'

module DogCollar
  module Logging
    class Logger < Logger
      def initialize(*, **)
        super
        @formatter = default_formatter if @formatter.nil?
        @before_hooks = []
      end

      def before_log(&block)
        @before_hooks << Proc.new
      end

      def debug(message = nil, **meta)
        add(::Logger::DEBUG, message, **meta)
      end

      def info(message = nil, **meta)
        add(::Logger::INFO, message, **meta)
      end

      def warn(message = nil, **meta)
        add(::Logger::WARN, message, **meta)
      end

      def error(message = nil, **meta)
        add(::Logger::ERROR, message, **meta)
      end

      def fatal(message = nil, **meta)
        add(::Logger::FATAL, message, **meta)
      end

      def add(severity, message = nil, **meta)
        severity ||= ::Logger::UNKNOWN
        meta = execute_before_hooks.merge(meta)
        @logdev.write(format_message(severity, Time.now, progname, message, meta))
        true
      end

      private
      def execute_before_hooks
        meta = {}
        @before_hooks.each do |hook|
          meta.update(hook.call)
        end
        meta
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
