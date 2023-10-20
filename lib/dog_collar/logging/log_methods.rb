# frozen_string_literal: true

module DogCollar
  module Logging
    module LogMethods
      LOG_SEV = {
        debug: Logger::DEBUG,
        info: Logger::INFO,
        warn: Logger::WARN,
        error: Logger::ERROR,
        fatal: Logger::FATAL
      }.freeze

      LOG_SEV.each do |method_name, severity|
        define_method(method_name) do |message = nil, progname = nil, **meta, &block|
          add(severity, message, progname, **meta, &block)
        end

        # Allow severity checks to work even when level is overriden in older
        # versions of Ruby (< 2.7.0).
        define_method("#{method_name}?") do
          level <= severity
        end
      end

      def add(severity, message = nil, progname = nil, **meta, &block)
        severity ||= ::Logger::UNKNOWN
        return true if @logdev.nil? || severity < level

        meta = execute_before_log_hooks.update(meta)
        message = evaluate_log_block(message, meta, &block)

        @logdev.write(format_message(severity, Time.now, progname, message, meta))
        true
      end

      alias log add
    end
  end
end
