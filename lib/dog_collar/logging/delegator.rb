# frozen_string_literal: true

module DogCollar
  module Logging
    class Delegator
      attr_accessor :logger

      def initialize(logger)
        @logger = logger
      end

      def method_missing(method_name, *args, &block)
        if logger.respond_to?(method_name)
          logger.send(method_name, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        super || logger.respond_to?(method, include_private)
      end
    end
  end
end
