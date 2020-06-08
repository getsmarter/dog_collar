# frozen_string_literal: true

module DogCollar
  module Contrib
    module Sidekiq
      module Ext
        ENV_TAG_JOB_ARGS = 'DD_SIDEKIQ_TAG_JOB_ARGS'
        TAG_JOB_RETRY_COUNT = 'sidekiq.job.retry_count'
        TAG_JOB_ENQUEUED_AT = 'sidekiq.job.enqueued_at'
        TAG_JOB_CREATED_AT = 'sidekiq.job.created_at'
        TAG_JOB_FAILED_AT = 'sidekiq.job.failed_at'
        TAG_JOB_RETRIED_AT = 'sidekiq.job.retried_at'
      end
    end
  end
end
