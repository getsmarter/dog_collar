# frozen_string_literal: true

require 'ddtrace'
require 'dog_collar/configuration'
require 'dog_collar/logging/logger'
require 'dog_collar/logging/instrumented_logger'

module DogCollar
  extend Configuration
end
