# frozen_string_literal: true

require 'dog_collar/contrib/rails/logger'

describe DogCollar::Contrib::Rails::Logger do
  let(:io) { StringIO.new }

  subject { described_class.new(io, service: 'foo') }

  describe '#add' do
    it 'should support log tags' do
      subject.info('hi', foo: 'bar')
      expect(JSON.parse(io.string)).to include('message' => 'hi', 'foo' => 'bar')
    end
  end

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
end
