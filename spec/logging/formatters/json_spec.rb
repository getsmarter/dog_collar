require 'dog_collar/logging/formatters/json'

describe DogCollar::Logging::Formatters::JSON do
  let(:formatter) { described_class.new }
  let(:severity) { Logger::DEBUG }
  let(:message) { "Hello, world!" }
  let(:progname) { "foo" }
  let(:meta) { { a: 1, b: 2, c: 3 } }
  let(:time) { Time.new(2001, 2, 3, 4, 5, 6, 0) }

  subject { JSON.parse(formatter.call(severity, time, progname, message, meta)) }

  context 'when a message is provided' do
    it 'includes the message' do
      expect(subject).to include("message" => message)
    end

    it 'formats the metadata' do
      expect(subject).to include(meta.stringify_keys)
    end
  end

  context 'when an exception is provided' do
    let(:message) { TestError.new('Oops!') }

    it 'formats the exception' do
      expect(subject).to include("error" => {
        "kind" => 'TestError',
        "message" => 'Oops!',
        "backtrace" => message.backtrace.join("\n")
      })
    end

    it 'formats the metadata' do
      expect(subject).to include(meta.stringify_keys)
    end
  end

  context 'when no message is provided' do
    let(:message) { nil }

    it 'does not include a message' do
      expect(subject).not_to have_key("message")
    end

    it 'formats the metadata' do
      expect(subject).to include(meta.stringify_keys)
    end
  end

  context 'when an object is provided' do
    let(:message) { Object.new }

    it 'formats the object' do
      expect(subject).to include("message" => message.inspect)
    end

    it 'formats the metadata' do
      expect(subject).to include(meta.stringify_keys)
    end
  end

  context 'when a datetime format is provided' do
    before do
      formatter.datetime_format = "%Y-%m-%d"
    end

    it 'uses the specified format' do
      expect(subject).to include("@timestamp" => '2001-02-03')
    end
  end

  context 'when no datetime format is provided' do
    it 'uses an IS08601 formatted timestamp with 3 milliseconds precision' do
      expect(subject).to include("@timestamp" => '2001-02-03T04:05:06.000+00:00')
    end
  end

  context 'when the severity is DEBUG' do
    it 'includes the level' do
      expect(subject).to include("status" => "debug")
    end
  end

  context 'when the severity is INFO' do
    let(:severity) { Logger::INFO }

    it 'includes the level' do
      expect(subject).to include("status" => "info")
    end
  end

  context 'when the severity is WARN' do
    let(:severity) { Logger::WARN }

    it 'includes the level' do
      expect(subject).to include("status" => "warn")
    end
  end

  context 'when the severity is ERROR' do
    let(:severity) { Logger::ERROR }

    it 'includes the level' do
      expect(subject).to include("status" => "error")
    end
  end

  context 'when the severity is FATAL' do
    let(:severity) { Logger::FATAL }

    it 'includes the level' do
      expect(subject).to include("status" => "fatal")
    end
  end

  context 'when the severity is unknown' do
    let(:severity) { 123 }

    it 'includes the level' do
      expect(subject).to include("status" => "any")
    end
  end
end
