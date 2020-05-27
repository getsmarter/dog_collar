require 'dog_collar'

# Monkey patch the Sidekiq module to allow server middleware to work in inline
# testing mode. Without this, the server middleware is ignored.
module Sidekiq
  def self.server_middleware
    yield Sidekiq::Testing.server_middleware if block_given?
    Sidekiq::Testing.server_middleware
  end

  def self.configure_server
    yield self
  end
end

describe 'Sidekiq' do
  let(:writer) { FakeWriter.new }

  before do
    DogCollar.configure do |config|
      config.service_name = 'foo'
      config.tracer = Datadog::Tracer.new(writer: writer)
      config.autoload!
    end
  end

  it 'creates a span for both the Sidekiq job push and pop' do
    expect { NoopWorker.perform_inline(nil) }.to change { writer.spans.length }.by(2)
  end

  it 'silences the default noisy logs' do
    expect(Sidekiq.logger.level).to eq(Logger::ERROR)
  end

  it 'replaces the default error handler'

  context 'tags' do
    let(:job) { writer.find_span_by_name('sidekiq.job') }

    before do
      NoopWorker.perform_inline(nil)
    end

    it 'does the thing' do
      expect(job.service).to eq('foo-sidekiq')
    end

    it 'adds the custom tags' do
      expect(job.get_tag('sidekiq.job.created_at')).to_not be_nil
    end

    it 'includes the job arguments' do
      expect(job.get_tag('sidekiq.job.args')).to_not be_nil
    end
  end
end
