# frozen_string_literal: true

require 'dog_collar/logging/formatters/json'
require 'dog_collar/logging/formatters/pretty'

module DogCollar
  module Logging
    class Logger < Logger
      LOG_SEV = {
        debug: Logger::DEBUG,
        info: Logger::INFO,
        warn: Logger::WARN,
        error: Logger::ERROR,
        fatal: Logger::FATAL
      }.freeze

      attr_accessor :formatter

      def self.before_log_hooks
        @_before_log_hooks ||= []
      end

      def before_log_hooks
        # Grab the hook methods from this class and its ancestors and bind them
        # to this instance. These hooks will be executed before any
        # instance-level hooks.
        @_before_log_hooks ||= inherited_before_log_hooks.map do |hook|
          hook.bind(self)
        end
      end

      def self.before_log(*hooks)
        hooks.each do |hook|
          before_log_hooks << instance_method(hook)
        end
      end

      def before_log
        before_log_hooks << Proc.new
      end

      def initialize(*, **kwargs)
        super
        # Ruby versions before 2.4.0 did not accept keyword arguments on the
        # constructor. Support progname, level and formatter.
        self.progname = kwargs.fetch(:progname, nil)
        self.level = kwargs.fetch(:level, DEBUG)
        self.formatter = kwargs.fetch(:formatter, default_formatter)
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
        child = dup
        child.before_log { meta }
        child
      end

      def add(severity, message = nil, **meta, &block)
        severity ||= ::Logger::UNKNOWN
        return true if @logdev.nil? || severity < level

        meta = execute_before_log_hooks.update(meta)
        message = evaluate_log_block(message, meta, &block)

        @logdev.write(format_message(severity, Time.now, progname, message, meta))
        true
      end

      alias log add

      private

      def logger_ancestors
        self.class.ancestors.select { |ancestor| ancestor <= DogCollar::Logging::Logger }
      end

      def inherited_before_log_hooks
        logger_ancestors.reverse.flat_map(&:before_log_hooks)
      end

      def execute_before_log_hooks
        meta = {}
        before_log_hooks.each do |hook|
          case hook
          when Proc
            meta.update(instance_eval(&hook))
          when Method
            meta.update(hook.call)
          end
        end
        meta
      end

      def evaluate_log_block(message, meta)
        return message unless block_given?

        result = yield meta
        message.nil? ? result : message
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
