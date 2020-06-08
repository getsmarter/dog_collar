# frozen_string_literal: true

require 'dog_collar/logging/formatters/pretty'

describe DogCollar::Logging::Formatters::Pretty do
  let(:formatter) { described_class.new }
  let(:severity) { Logger::DEBUG }
  let(:message) { 'Hello, world!' }
  let(:meta) { { a: 1, b: 2, c: 3 } }
  let(:time) { Time.new(2001, 2, 3, 4, 5, 6) }

  subject { formatter.call(severity, time, 'foo', message, meta) }

  context 'when a message is provided' do
    it 'includes the message' do
      expect(subject).to include(message)
    end

    it 'formats the metadata' do
      expect(subject.gsub(/\e\[([;\d]+)?m/, '')).to include(':b => 2,')
    end
  end

  context 'when an exception is provided' do
    let(:message) { TestError.new('Oops!') }

    it 'formats the exception' do
      expect(subject).to include("TestError Oops!\n    #{message.backtrace.first}")
    end

    it 'formats the metadata' do
      expect(subject.gsub(/\e\[([;\d]+)?m/, '')).to include(':b => 2,')
    end
  end

  context 'when no message is provided' do
    let(:message) { nil }

    it 'does not include a message' do
      expect(subject.split("\n").first).to end_with(': ')
    end

    it 'formats the metadata' do
      expect(subject.gsub(/\e\[([;\d]+)?m/, '')).to include(':b => 2,')
    end
  end

  context 'when an object is provided' do
    let(:message) { Object.new }

    it 'formats the object' do
      expect(subject).to include('#<Object:0x')
    end

    it 'formats the metadata' do
      expect(subject.gsub(/\e\[([;\d]+)?m/, '')).to include(':b => 2,')
    end
  end

  context 'when a datetime format is provided' do
    before do
      formatter.datetime_format = '%Y-%m-%d'
    end

    it 'uses the specified format' do
      expect(subject).to start_with('[2001-02-03]')
    end
  end

  context 'when no datetime format is provided' do
    it 'uses the default format' do
      expect(subject).to start_with('[2001 Feb 3 04:05:06]')
    end
  end

  context 'when the severity is DEBUG' do
    it 'includes the level' do
      expect(subject).to include("\e[0;37mDEBUG\e[0m")
    end
  end

  context 'when the severity is INFO' do
    let(:severity) { Logger::INFO }

    it 'includes the level' do
      expect(subject).to include("\e[0;36mINFO\e[0m")
    end
  end

  context 'when the severity is WARN' do
    let(:severity) { Logger::WARN }

    it 'includes the level' do
      expect(subject).to include("\e[0;33mWARN\e[0m")
    end
  end

  context 'when the severity is ERROR' do
    let(:severity) { Logger::ERROR }

    it 'includes the level' do
      expect(subject).to include("\e[0;31mERROR\e[0m")
    end
  end

  context 'when the severity is FATAL' do
    let(:severity) { Logger::FATAL }

    it 'includes the level' do
      expect(subject).to include("\e[0;35mFATAL\e[0m")
    end
  end

  context 'when the severity is unknown' do
    let(:severity) { 123 }

    it 'includes the level' do
      expect(subject).to include("\e[0;32mANY\e[0m")
    end
  end
end
