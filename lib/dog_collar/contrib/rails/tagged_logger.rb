# frozen_string_literal: true

require 'dog_collar/logging/delegator'

module DogCollar
  module Contrib
    module Rails
      class TaggedLogger < DogCollar::Logging::Delegator
        module Hooks
          def current_tags
            thread_key = @thread_key ||= "dogcollar_rails_tagged_logging_tags:#{object_id}"
            Thread.current[thread_key] ||= []
          end

          def self.extended(base)
            base.before_log do
              tags = current_tags
              if tags.empty?
                {}
              else
                { tags: current_tags }
              end
            end
          end
        end

        def initialize(logger)
          super(logger.dup.extend(Hooks))
        end

        def tagged(*tags, &block)
          if block_given?
            tagged_block(*tags, &block)
          else
            dup.tap { |tagged_logger| tagged_logger.push_tags(*tags) }
          end
        end

        protected

        def push_tags(*tags)
          tags = tags.flatten.reject(&:blank?)
          logger.current_tags.concat(tags)
          tags
        end

        private

        def pop_tags(count)
          logger.current_tags.pop(count)
        end

        def tagged_block(*tags)
          new_tags = push_tags(*tags)
          yield self
        ensure
          pop_tags(new_tags.length)
        end
      end
    end
  end
end
