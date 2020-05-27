require 'ddtrace'
require 'dog_collar/contrib/sidekiq/patcher'

module DogCollar
  module Contrib
    module Sidekiq
      class Integration < Datadog::Contrib::Sidekiq::Integration
        register_as :sidekiq

        def patcher
          DogCollar::Contrib::Sidekiq::Patcher
        end
      end
    end
  end
end
