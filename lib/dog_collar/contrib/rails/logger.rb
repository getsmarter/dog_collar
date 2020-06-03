require 'dog_collar/logging/delegator'
require 'active_support'

module DogCollar
  module Contrib
    module Rails
      class Logger < DogCollar::Logging::InstrumentedLogger
        cattr_accessor :silencer, default: false

        def silence(severity = Logger::ERROR)
          silencer ? log_at(severity) { yield self } : yield(self)
        end
      end
    end
  end
end
