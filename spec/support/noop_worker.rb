require 'sidekiq'
require 'sidekiq/testing'

class NoopWorker
  include Sidekiq::Worker

  def perform(_)
  end

  def self.perform_inline(*args)
    Sidekiq::Testing.inline! { perform_async(*args) }
  end
end
