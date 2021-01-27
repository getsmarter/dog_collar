# frozen_string_literal: true

require 'dog_collar/logging/delegator'
require 'dog_collar/logging/instrumented_logger'
require 'active_support'

module DogCollar
  module Contrib
    module Rails
      class Logger < DogCollar::Logging::InstrumentedLogger
        if ActiveSupport.version >= Gem::Version.new('6.0.0')
            include ActiveSupport::LoggerSilence
        else
            include LoggerSilence
        end

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
