module DogCollar
  module Logging
    class Delegator
      attr_accessor :logger

      def initialize(logger)
        @logger = logger
      end

      def method_missing(method_name, *args, &block)
        logger.send(method_name, *args, &block)
      end
    end
  end
end
