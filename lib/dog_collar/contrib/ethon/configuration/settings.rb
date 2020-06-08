# frozen_string_literal: true

module DogCollar
  module Contrib
    module Ethon
      module Configuration
        class Settings < Datadog::Contrib::Ethon::Configuration::Settings
          option :split_by_domain, default: true
        end
      end
    end
  end
end
