# frozen_string_literal: true

require 'dog_collar/contrib/circuitry/ext'

module DogCollar
  module Contrib
    module Circuitry
      class TracingMiddleware
        def call(topic, message)
          context = datadog_context_from_message(message)
          Datadog.tracer.provider.context = context if context&.trace_id

          Datadog.tracer.trace(Ext::SPAN_MESSAGE) do |span|
            span.service = configuration[:service_name]
            span.span_type = Ext::SPAN_TYPE
            span.resource = topic
            span.set_tag(Ext::TAG_MESSAGE, message)
            yield
          end
        end

        def configuration
          Datadog.configuration[:circuitry]
        end

        private

        def datadog_context_from_message(message)
          identifier = message['_dd']
          return if identifier.nil?

          Datadog::Context.new(
            trace_id: identifier['trace_id'],
            span_id: identifier['span_id'],
            sampling_priority: identifier['sampling_priority']
          )
        end
      end
    end
  end
end
