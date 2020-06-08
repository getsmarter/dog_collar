# frozen_string_literal: true

require 'ddtrace'
require 'dog_collar/contrib/rails/patcher'
require 'dog_collar/contrib/rails/configuration/settings'
require 'dog_collar/contrib/rails/lograge/delegating_logger'
require 'dog_collar/contrib/rails/logger'
require 'dog_collar/contrib/rails/tagged_logger'

module DogCollar
  module Contrib
    module Rails
      class Integration < Datadog::Contrib::Rails::Integration
        register_as :rails

        def default_configuration
          Configuration::Settings.new
        end

        def patcher
          DogCollar::Contrib::Rails::Patcher
        end
      end
    end
  end
end
