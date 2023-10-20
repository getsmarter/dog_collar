# frozen_string_literal: true

require 'stringio'
require 'dog_collar/logging/logger'

describe DogCollar::Logging::Logger do
  let(:io) { StringIO.new }
  let(:logger) { described_class.new(io, progname: 'foo') }

  before do
    allow(Time).to receive(:now).and_return(Time.new)
  end

  describe '#formatter' do
    it 'defaults to the JSON formatter' do
      expect(logger.formatter).to be_a(DogCollar::Logging::Formatters::JSON)
    end
  end

  describe '#add' do
    let(:formatter) { double }
    let(:time) { Time.now }
    let(:severity) { Logger::INFO }
    let(:progname) { 'foobar' }
    let(:msg) { 'Hello, world!' }
    let(:meta) { { a: 1, b: 2, c: 3 } }
    let(:logger) { described_class.new(io, progname: progname) }

    before do
      logger.formatter = formatter
    end

    context 'when a block is provided' do
      it 'forwards the return value as the log message' do
        expect(formatter).to receive(:call).with(severity, time, nil, msg, meta)
        logger.add(severity, **meta) { msg }
      end

      it 'allows the user to modify the metadata inside the block' do
        expect(formatter).to receive(:call).with(severity, time, nil, msg, **meta, d: 4)
        logger.add(severity, **meta) do |meta|
          meta[:d] = 4
          msg
        end
      end

      it 'doesn not overwrite the message argument' do
        expect(formatter).to receive(:call).with(severity, time, progname, msg, **meta, d: 4)
        logger.add(severity, msg, progname, **meta) do |meta|
          meta[:d] = 4
          'Overwrite'
        end
      end
    end

    context 'when a message is provided' do
      it 'calls the provided formatter' do
        expect(formatter).to receive(:call).with(severity, time, progname, msg, meta)
        logger.add(severity, msg, progname, **meta)
      end
    end

    context 'when no message is provided' do
      it 'calls the provided formatter' do
        expect(formatter).to receive(:call).with(severity, time, nil, nil, meta)
        logger.add(severity, **meta)
      end
    end
  end

  describe '#before_log' do
    let(:formatter) { double }

    before do
      logger.formatter = formatter
      logger.before_log { { b: 100, c: 3 } }
      logger.before_log { { a: 100, b: 2 } }
    end

    it 'adds the resulting hash to the metadata on future logs' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1, b: 2, c: 3)
      logger.info('foo', a: 1) # metadata here should override metadata from hooks
    end

    it 'does not affect other instances' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1)
      described_class.new(io, formatter: formatter).info('foo', a: 1)
    end
  end

  describe '#with' do
    class DerivedLogger < described_class
      def add_meta
        { b: 100, c: 100 }
      end

      before_log :add_meta
    end

    class ExtraDerivedLogger < DerivedLogger
      def add_meta
        { c: 3, d: 100 }
      end

      before_log :add_meta
    end

    let(:formatter) { double }
    let(:logger) { ExtraDerivedLogger.new(io, formatter: formatter) }
    let!(:child) { logger.with(a: 100, b: 2).with(d: 4, e: 5) }

    it 'merges in all the metadata' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1, b: 2, c: 3, d: 4, e: 5)
      child.info('foo', a: 1)
    end

    it 'leaves the parent unchanged' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1, b: 100, c: 3, d: 100)
      logger.info('foo', a: 1)
    end

    it 'does not affect other instances' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1, b: 100, c: 3, d: 100)
      ExtraDerivedLogger.new(io, formatter: formatter).info('foo', a: 1)
    end

    it 'does not affect other instances of the parent' do
      expect(formatter).to receive(:call).with(anything, anything, anything, anything, a: 1, b: 100, c: 100)
      DerivedLogger.new(io, formatter: formatter).info('foo', a: 1)
    end
  end

  described_class::LOG_SEV.each do |method, severity|
    describe "##{method}" do
      let(:meta) { { a: 1, b: 2, c: 3 } }

      described_class::LOG_SEV.each do |label, level|
        context "when the level is #{label} and a block is given" do
          before do
            logger.level = level
          end

          if level > severity
            it 'does not yield' do
              expect { |b| logger.add(severity, **meta, &b) }.not_to yield_control
            end
          else
            it 'yields' do
              expect { |b| logger.add(severity, **meta, &b) }.to yield_with_args(meta)
            end
          end
        end
      end

      context 'when a message is provided' do
        let(:message) { 'foobar' }

        it 'calls #add with the correct severity' do
          expect(logger).to receive(:add).with(severity, message, nil, **meta)
          logger.send(method, message, **meta)
        end
      end

      context 'when no message is provided' do
        it 'calls #add with the correct severity' do
          expect(logger).to receive(:add).with(severity, nil, nil, **meta)
          logger.send(method, **meta)
        end
      end
    end

    describe "##{method}?" do
      let(:order) { %i[debug info warn error fatal] }
      let(:index) { severity + 1 }
      let(:lower_severities) { order.take(index) }
      let(:higher_severities) { order.drop(index) }

      described_class::LOG_SEV.each do |label, level|
        context "when the level is #{label}" do
          before do
            logger.level = level
          end

          if level > severity
            it 'returns false' do
              expect(logger.send("#{method}?")).to be(false)
            end
          else
            it 'returns true' do
              expect(logger.send("#{method}?")).to be(true)
            end
          end
        end
      end
    end
  end
end
