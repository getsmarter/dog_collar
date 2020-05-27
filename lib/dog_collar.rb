require 'dog_collar/configuration'

module DogCollar
  extend Configuration
end

require 'dog_collar/contrib/sidekiq/integration'
require 'dog_collar/contrib/rails/integration'
