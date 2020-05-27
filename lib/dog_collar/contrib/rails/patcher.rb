module DogCollar
  module Contrib
    module Rails
      module Patcher
        include Datadog::Contrib::Rails::Patcher

        module_function

        def patch
          Datadog::Contrib::Rails::Patcher.patch
          require 'lograge'

          ::Rails.application.configure do
            config.lograge.enabled = true
            # config.lograge.formatter = GroundControl::Lograge::Formatter.new
            # config.log_level = :info
            # config.logger = GroundControl::Logger.new(STDOUT)
          end
        end
      end
    end
  end
end
