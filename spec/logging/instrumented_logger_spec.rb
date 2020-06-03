describe DogCollar::Logging::InstrumentedLogger do
  let(:io) { StringIO.new }
  let(:formatter) { proc { |_, _, _, _, meta| meta.to_json } }
  let(:logger) { described_class.new(io, formatter: formatter) }
  let(:subject) { logger.info && JSON.parse(io.string) }

  context 'when a service name is given' do
    before do
      DogCollar.configure do |config|
        config.service = 'foobar'
      end
    end

    it 'sets the service tag' do
      expect(subject).to include('service' => 'foobar')
    end
  end

  context 'when it is initialized with a service' do
    let(:logger) { described_class.new(io, formatter: formatter, service: 'baz') }

    it 'uses the configured service name' do
      expect(subject).to include('service' => 'baz')
    end
  end

  context 'when no service name is given' do
    before do
      DogCollar.configure do |config|
        config.service = nil
      end
    end

    it 'excludes the service tag' do
      expect(subject).to_not have_key('service')
    end
  end

  context 'when there is an active trace' do
    before do
      allow(Datadog.tracer).to receive(:active_correlation).and_return(OpenStruct.new(trace_id: 123, span_id: 456))
    end

    it 'sets the trace and span id' do
      expect(subject).to include("dd" => { "trace_id" => 123, "span_id" => 456 })
    end
  end

  context 'when there is no active trace' do
    before do
      allow(Datadog.tracer).to receive(:active_correlation).and_return(OpenStruct.new(trace_id: 0))
    end

    it 'excludes the trace and span id' do
      expect(subject).to_not have_key('dd')
    end
  end
end
