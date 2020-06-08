# frozen_string_literal: true

require 'dog_collar/contrib/sidekiq/ext'

module DogCollar
  module Contrib
    module Sidekiq
      class ServerTracer
        def call(_worker, job, _queue)
          add_job_tags_to_span(Datadog.tracer.active_span, job)
          job['dd'] = datadog_trace_context
          yield
        end

        private

        def add_job_tags_to_span(span, job)
          span.set_tag(Ext::TAG_JOB_RETRY_COUNT, job['retry_count'])
          span.set_tag(Ext::TAG_JOB_ENQUEUED_AT, job['enqueued_at'])
          span.set_tag(Ext::TAG_JOB_FAILED_AT, job['failed_at'])
          span.set_tag(Ext::TAG_JOB_RETRIED_AT, job['retried_at'])
          span.set_tag(Ext::TAG_JOB_CREATED_AT, job['created_at'])
        end

        def datadog_trace_context
          correlation = Datadog.tracer.active_correlation
          { trace_id: correlation.trace_id, span_id: correlation.span_id }
        end
      end
    end
  end
end
