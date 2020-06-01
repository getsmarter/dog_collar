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
      config.logger = Logger.new(STDOUT)
      config.service_name = 'foo'
      config.tracer = Datadog::Tracer.new(writer: writer)
      config.autoload!
    end
  end

  it 'sets the logger' do
    skip
    expect(Rails.application.config.logger).to eq(Datadog.configuration.logger.instance)
  end

  context 'lograge' do
    let(:logger) { double }

    before do
      DogCollar.configure do |config|
        config.logger = logger
      end
    end

    it 'is enabled' do
      expect(Rails.application.config.lograge.enabled).to be(true)
    end

    it 'uses the raw formatter' do
      expect(Rails.application.config.lograge.formatter).to be_a(Lograge::Formatters::Raw)
    end

    it 'uses the delegating logger' do
      skip
      expect(Rails.application.config.lograge.logger)
        .to be_a(DogCollar::Contrib::Rails::Lograge::DelegatingLogger)

      expect(Rails.application.config.lograge.logger.logger).to eq(Datadog.configuration.logger.instance)
    end
  end
end
