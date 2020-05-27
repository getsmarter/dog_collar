require 'dog_collar'

require "rails"
module Test
  class Application < Rails::Application
  end
end

describe DogCollar::Contrib::Rails do

  let(:writer) { FakeWriter.new }

  before do
    DogCollar.configure do |config|
      config.service_name = 'foo'
      config.tracer = Datadog::Tracer.new(writer: writer)
      config.autoload!
    end
  end

  context 'lograge' do
    it 'is enabled' do
      expect(Rails.application.config.lograge.enabled).to be(true)
    end

    it 'uses the custom formatter' do
      skip
    end
  end
end
