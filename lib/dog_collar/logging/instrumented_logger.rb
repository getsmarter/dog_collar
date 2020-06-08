# frozen_string_literal: true

require 'dog_collar/logging/logger'

module DogCollar
  module Logging
    class InstrumentedLogger < Logger
      attr_writer :service

      def initialize(*args, **extra)
        @service = extra.delete(:service)
        super(*args, **extra)
      end

      private

      def service
        @service || Datadog.configuration.service
      end

      def add_trace_context
        correlation = Datadog.tracer.active_correlation

        if correlation.trace_id != 0
          { dd: format_correlation_identifier(correlation) }
        else
          {}
        end
      end

      def add_service_tag
        if service.nil?
          {}
        else
          { service: service }
        end
      end

      def format_correlation_identifier(correlation)
        { trace_id: correlation.trace_id, span_id: correlation.span_id }
      end

      before_log :add_service_tag, :add_trace_context
    end
  end
end
