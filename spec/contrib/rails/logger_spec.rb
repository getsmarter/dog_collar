# frozen_string_literal: true

require 'dog_collar/contrib/rails/logger'

describe DogCollar::Contrib::Rails::Logger do
  let(:io) { StringIO.new }

  subject { described_class.new(io, service: 'foo') }

  describe '#silence' do
    context 'when silencer is true' do
      before do
        subject.silencer = true
      end

      it 'silences the log' do
        subject.silence do
          subject.info('foo')
        end

        expect(io.string).to be_empty
      end
    end

    context 'when silencer is false' do
      before do
        subject.silencer = false
      end

      it 'silences the log' do
        subject.silence do
          subject.info('foo')
        end

        expect(io.string).not_to be_empty
      end
    end
  end

  describe '#log_at' do
    it 'yields' do
      expect { |b| subject.log_at(:error, &b) }.to yield_control
    end

    it 'changes the log level' do
      expect(subject.level).to be(Logger::Severity::DEBUG)

      subject.log_at(:error) do
        expect(subject.level).to be(Logger::Severity::ERROR)
      end

      expect(subject.level).to be(Logger::Severity::DEBUG)
    end

    it 'changes back even when the block raises an exception' do
      expect {
        subject.log_at(:error) { raise 'boom!' }
      }.to raise_error(StandardError)

      expect(subject.level).to be(Logger::Severity::DEBUG)
    end

    it 'is thread-safe' do
      inside_second_log_at = Notifier.new
      log_at_started = Notifier.new

      t = Thread.new do
        subject.log_at(:error) do
          log_at_started.notify
          inside_second_log_at.wait_for_notification
          expect(subject.level).to eq(Logger::Severity::ERROR)
        end
      end

      t.abort_on_exception = true
      t.report_on_exception = false
      log_at_started.wait_for_notification

      subject.log_at(:warn) do
        inside_second_log_at.notify
        expect(subject.level).to eq(Logger::Severity::WARN)
      end

      t.join
    end
  end
end
