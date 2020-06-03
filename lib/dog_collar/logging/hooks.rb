module DogCollar
  module Logging
    module Hooks
      module ExecutionHooks
        def before_log(*hooks, &block)
          hook_methods = hooks.map { |hook| instance_method(hook) }
          original_method = instance_method(:add)

          define_method(:add) do |severity, message = nil, **meta, &b|
            final_meta = {}

            # Later hooks should override the metadata from earlier ones,
            # followed by the blocks, before being overwritten by the metadata
            # passed into the log call
            hook_methods.each do |hook_method|
              final_meta.update(hook_method.bind(self).call)
            end
            final_meta.update(block.call) if block_given?
            final_meta.update(meta)

            original_method.bind(self).call(severity, message, **final_meta, &b)
          end
        end
      end

      def before_log(&block)
        self.class.before_log(&block)
      end

      def self.included(base)
        base.send(:extend, ExecutionHooks)
      end
    end
  end
end
