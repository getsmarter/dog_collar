# frozen_string_literal: true

require 'dog_collar/logging/delegator'

module DogCollar
  module Contrib
    module Rails
      class TaggedLogger < DogCollar::Logging::Delegator
        def tagged(*tags, &block)
          if block_given?
            tagged_block(*tags, &block)
          else
            TaggedLogger.new(build_with_tags(tags))
          end
        end

        private

        def tagged_block(*tags)
          old_logger = logger
          self.logger = build_with_tags(tags)
          yield
        ensure
          self.logger = old_logger
        end

        def build_with_tags(tags)
          meta = Hash[tags.flatten.reject(&:blank?).collect { |v| [v.to_sym, v] }]
          logger.with(**meta)
        end
      end
    end
  end
end
