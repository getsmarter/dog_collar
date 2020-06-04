require 'dog_collar/logging/delegator'
require 'dog_collar/logging/instrumented_logger'
require 'active_support'

module DogCollar
  module Contrib
    module Rails
      class Logger < DogCollar::Logging::InstrumentedLogger
        cattr_accessor :silencer, default: true
        cattr_accessor :local_levels, default: Concurrent::Map.new(initial_capacity: 2), instance_accessor: false

        def local_log_id
          Fiber.current.__id__
        end

        def local_level
          self.class.local_levels[local_log_id]
        end

        def local_level=(level)
          case level
          when Integer
            self.class.local_levels[local_log_id] = level
          when Symbol
            self.class.local_levels[local_log_id] = Logger::Severity.const_get(level.to_s.upcase)
          when nil
            self.class.local_levels.delete(local_log_id)
          else
            raise ArgumentError, "Invalid log level: #{level.inspect}"
          end
        end

        def level
          local_level || super
        end

        def log_at(level)
          old_local_level, self.local_level = local_level, level
          yield
        ensure
          self.local_level = old_local_level
        end

        def silence(severity = Logger::ERROR)
          silencer ? log_at(severity) { yield self } : yield(self)
        end
      end
    end
  end
end
