# frozen_string_literal: true

require 'dog_collar/logging/delegator'
require 'forwardable'

module DogCollar
  module Contrib
    module Rails
      class TaggedLogger < DogCollar::Logging::Delegator
        extend Forwardable

        module Formatter
          def current_tags
            thread_key = @thread_key ||= "dogcollar_rails_tagged_logging_tags:#{object_id}"
            Thread.current[thread_key] ||= []
          end

          def push_tags(*tags)
            tags = tags.flatten.reject(&:blank?)
            current_tags.concat(tags)
            tags
          end

          def pop_tags(count)
            current_tags.pop(count)
          end

          def clear_tags!
            current_tags.clear
          end
        end

        module Hooks
          def self.extended(base)
            base.before_log do
              tags = formatter.current_tags
              if tags.empty?
                {}
              else
                { tags: formatter.current_tags }
              end
            end
          end
        end

        def initialize(logger)
          logger = logger.dup
          logger.formatter = logger.formatter.dup
          logger.formatter.extend(Formatter)

          super(logger.dup.extend(Hooks))
        end

        def tagged(*tags, &block)
          if block_given?
            tagged_block(*tags, &block)
          else
            dup.tap { |tagged_logger| tagged_logger.push_tags(*tags) }
          end
        end

        def_delegators :formatter, :push_tags, :pop_tags, :clear_tags!

        private

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
