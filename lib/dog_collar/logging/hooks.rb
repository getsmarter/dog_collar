module DogCollar
  module Logging
    module Hooks
      module ExecutionHooks
        def before_log(*hooks)
          hook_methods = hooks.map { |hook| instance_method(hook) }
          original_method = instance_method(:add)

          define_method(:add) do |severity, message = nil, **meta, &b|
            final_meta = {}
            hook_methods.each do |hook_method|
              final_meta.update(hook_method.bind(self).call)
            end
            final_meta.update(meta)

            original_method.bind(self).call(severity, message, **final_meta, &b)
          end
        end
      end

      def before_log(&block)
        original_method = method(:add)

        define_singleton_method(:add) do |severity, message = nil, **meta, &b|
          final_meta = {}
          final_meta.update(block.call) if block_given?
          final_meta.update(meta)

          original_method.call(severity, message, **final_meta, &b)
        end
      end

      def self.included(base)
        base.send(:extend, ExecutionHooks)
      end
    end
  end
end
