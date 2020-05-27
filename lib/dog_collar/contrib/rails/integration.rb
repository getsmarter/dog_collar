require 'ddtrace'
require 'dog_collar/contrib/rails/patcher'

module DogCollar
  module Contrib
    module Rails
      class Integration < Datadog::Contrib::Rails::Integration
        register_as :rails

        def patcher
          DogCollar::Contrib::Rails::Patcher
        end
      end
    end
  end
end
