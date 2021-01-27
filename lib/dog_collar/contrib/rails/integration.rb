# frozen_string_literal: true

require 'ddtrace'

require 'dog_collar/contrib/rails/patcher'

module DogCollar
  module Contrib
    module Rails
      class Integration < Datadog::Contrib::Rails::Integration
        register_as :rails

        def default_configuration
          require 'dog_collar/contrib/rails/configuration/settings'

          Configuration::Settings.new
        end

        def patcher
          require 'dog_collar/contrib/rails/lograge/delegating_logger'
          require 'dog_collar/contrib/rails/logger'
          require 'dog_collar/contrib/rails/tagged_logger'

          DogCollar::Contrib::Rails::Patcher
        end
      end
    end
  end
end
