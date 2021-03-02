# frozen_string_literal: true

require 'dog_collar/logging/delegator'

module DogCollar
  module Contrib
    module Rails
      module Lograge
        class DelegatingLogger < DogCollar::Logging::Delegator
          %i[debug info warn error fatal].each do |method_name|
            define_method(method_name) do |data|
              return logger.send(method_name, data) if data.is_a? String

              logger.send(method_name, build_message(**data), data)
            end
          end

          private

          def build_message(data)
            method, path, status, controller, action, format = data.values_at(
              :method, :path, :status, :controller, :action, :format
            )

            "#{method} #{path} (#{status}) -> #{controller}##{action}.#{format}"
          end
        end
      end
    end
  end
end
