require 'dog_collar'
require 'circuitry'

# Stub Circuitry with a mock SQS client
module Circuitry
  module Services
    module SQS
      def self.test_client
        @client ||= Aws::SQS::Client.new(stub_responses: true)
      end

      def sqs
        SQS.test_client
      end
    end
  end
end

describe DogCollar::Contrib::Circuitry do
  let(:writer) { FakeWriter.new }
  let(:sqs) { Circuitry::Services::SQS.test_client }
  let(:sns) { Circuitry::Services::SNS.test_client }

  before do
    DogCollar.configure do |config|
      config.service = 'foo'
      config.tracer = Datadog::Tracer.new(writer: writer)
      config.autoload!
    end

    Circuitry.subscriber_config do |config|
      config.queue_name = 'foo'
      config.access_key = 'YOUR_AWS_ACCESS_KEY'
      config.secret_key = 'YOUR_AWS_SECRET_KEY'

      # Silence logger in testing
      config.logger.level = :error

      # Stop swallowing exceptions during testing
      config.error_handler = Proc.new do |e|
        raise e
      end
    end

    sqs.stub_responses(:get_queue_url, queue_url: queue_url)
    sqs.stub_responses(:get_queue_attributes, attributes: { "QueueArn" => queue_arn })

    # SNS fanout to SQS encodes the SNS message to JSON inside the SQS message
    # body. Furthermore, Circuitry expects the SNS message body to be a JSON
    # encoded payload, leading to this nested JSON encoding.
    sqs.stub_responses(:receive_message, messages: [{
      message_id: SecureRandom.uuid,
      receipt_handle: 'rh123',
      body: JSON.dump(Message: JSON.dump(message), TopicArn: topic_arn)
    }])

    receive_message_and_exit
  end

  let(:subscriber) { Circuitry::Subscriber.new }
  let(:topic_arn) { 'arn:aws:sns:us-east-2:123456789012:My-Topic' }
  let(:queue_arn) { 'arn:aws:sqs:ap-northeast-1:123456789123:test' }
  let(:queue_url) { 'https://sqs.us-east-1.amazonaws.com/12345/test' }
  let(:message) { { "foo" => { "bar" => 1 } } }

  def receive_message_and_exit
    subscriber.subscribe do |message, topic|
      expect(Datadog.tracer.active_span).to_not be_nil

      # HACK Stop the subscriber from listening for further messages. You could
      # also raise SIGINT somehow to achieve the same thing
      subscriber.send('subscribed=', false)
    end
  end

  subject { writer.find_span_by_name('circuitry.subscriber.message') }

  it 'sets the logger' do
    expect(Circuitry.subscriber_config.logger).to be_a(DogCollar::Logging::InstrumentedLogger)
  end

  it 'sets the topic to the span name' do
    expect(subject.resource).to eq('My-Topic')
  end

  it 'sets the service name' do
    expect(subject.service).to eq('foo-circuitry')
  end

  it 'sets the message as a tag on the span' do
    expect(subject.get_tag('circuitry.message')).to eq(message.to_s)
  end
end
