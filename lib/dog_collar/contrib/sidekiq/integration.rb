require 'ddtrace'
require 'dog_collar/contrib/sidekiq/patcher'
require 'dog_collar/contrib/sidekiq/configuration/settings'

module DogCollar
  module Contrib
    module Sidekiq
      class Integration < Datadog::Contrib::Sidekiq::Integration
        register_as :sidekiq

        def default_configuration
          Configuration::Settings.new
        end

        def patcher
          DogCollar::Contrib::Sidekiq::Patcher
        end
      end
    end
  end
end
