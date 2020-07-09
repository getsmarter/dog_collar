# frozen_string_literal: true

require 'dog_collar/logging/delegator'
require 'dog_collar/logging/instrumented_logger'
require 'active_support'

module DogCollar
  module Contrib
    module Rails
      class Logger < DogCollar::Logging::InstrumentedLogger
        include LoggerSilence
        include ActiveSupport::LoggerThreadSafeLevel
        include DogCollar::Logging::LogMethods

        def initialize(*args, **kwargs)
          super
          after_initialize if respond_to? :after_initialize
        end
      end
    end
  end
end
