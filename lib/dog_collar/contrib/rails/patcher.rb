# frozen_string_literal: true

module DogCollar
  module Contrib
    module Rails
      module Patcher
        include Datadog::Contrib::Rails::Patcher

        module_function

        def patch
          Datadog::Contrib::Rails::Patcher.patch
          require 'lograge'
          require 'dog_collar/contrib/rails/railtie'
        end
      end
    end
  end
end
