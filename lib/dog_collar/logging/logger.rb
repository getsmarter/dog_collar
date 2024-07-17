# frozen_string_literal: true

require 'dog_collar/logging/formatters/json'
require 'dog_collar/logging/formatters/pretty'
require 'dog_collar/logging/log_methods'

module DogCollar
  module Logging
    class Logger < Logger
      include LogMethods

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

      def before_log(&block)
        before_log_hooks << Proc.new(&block)
      end

      def initialize(*, **kwargs)
        super
        # Ruby versions before 2.4.0 did not accept keyword arguments on the
        # constructor. Support progname, level and formatter.
        self.progname = kwargs.fetch(:progname, nil)
        self.level = kwargs.fetch(:level, DEBUG)
        self.formatter = kwargs.fetch(:formatter, default_formatter)
      end

      def with(**meta)
        child = dup
        child.before_log { meta }
        child
      end

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

      def format_message(severity, datetime, progname, msg, meta={})
        severity = severity.is_a?(String) ? level : severity
        
        (@formatter || @default_formatter).call(severity, datetime, progname, msg, meta)
      end
    end
  end
end
