# frozen_string_literal: true

require 'dog_collar'

require 'rails'
module Test
  class Application < Rails::Application
  end
end

describe DogCollar::Contrib::Rails do
  let(:writer) { FakeWriter.new }

  before do
    DogCollar.configure do |config|
      config.service = 'foo'
      config.tracer = Datadog::Tracer.new(writer: writer)
      config.autoload!
    end
  end

  it 'sets the logger' do
    expect(Rails.logger).to be_a(DogCollar::Contrib::Rails::TaggedLogger)
    expect(Rails.logger.logger).to be_a(DogCollar::Contrib::Rails::Logger)
  end

  context 'lograge' do
    let(:logger) { double }

    it 'is enabled' do
      expect(Rails.application.config.lograge.enabled).to be(true)
    end

    it 'uses the raw formatter' do
      expect(Rails.application.config.lograge.formatter).to be_a(Lograge::Formatters::Raw)
    end

    it 'uses the delegating logger' do
      expect(Rails.application.config.lograge.logger)
        .to be_a(DogCollar::Contrib::Rails::Lograge::DelegatingLogger)

      expect(Rails.application.config.lograge.logger.logger).to equal(Rails.logger)
    end
  end
end
