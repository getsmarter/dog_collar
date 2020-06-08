# frozen_string_literal: true

require 'dog_collar/configuration'
require 'dog_collar/logging/logger'
require 'dog_collar/logging/instrumented_logger'

module DogCollar
  extend Configuration
end

require 'dog_collar/contrib/sidekiq/integration'
require 'dog_collar/contrib/rails/integration'
require 'dog_collar/contrib/circuitry/integration'
require 'dog_collar/contrib/ethon/integration'
