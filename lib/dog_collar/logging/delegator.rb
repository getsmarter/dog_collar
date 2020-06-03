module DogCollar
  module Logging
    class Delegator
      attr_accessor :logger

      def initialize(logger)
        @logger = logger
      end

      def method_missing(method_name, *args)
        logger.send(method_name, *args)
      end
    end
  end
end
