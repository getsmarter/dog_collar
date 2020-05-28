require 'dog_collar/contrib/circuitry/ext'

module DogCollar
  module Contrib
    module Circuitry
      class TracingMiddleware
        def call(topic, message)
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
      end
    end
  end
end
