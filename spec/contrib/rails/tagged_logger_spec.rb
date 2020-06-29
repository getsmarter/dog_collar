# frozen_string_literal: true

require 'dog_collar/contrib/rails/logger'
require 'dog_collar/contrib/rails/tagged_logger'

describe DogCollar::Contrib::Rails::TaggedLogger do
  let(:io) { StringIO.new }
  let(:logger) { described_class.new(DogCollar::Logging::Logger.new(io)) }

  subject { JSON.parse(io.string) }

  describe '#tagged' do
    context 'when given a block' do
      it 'includes the tags as metadata' do
        logger.tagged('BCX') { logger.tagged('Jason') { logger.info('Stuff') } }
        is_expected.to include('tags' => ['BCX', 'Jason'])
      end

      it 'removes the tags after the block even when an exception is raised' do
        expect { logger.tagged('BCX') { raise 'stop' } }.to raise_error(RuntimeError)

        io.rewind

        logger.info('Stuff')
        is_expected.not_to have_key('tags')
      end
    end

    context 'when not given a block' do
      it 'includes the tags as metadata' do
        logger.tagged('BCX').tagged('Jason').info('Stuff')
        is_expected.to include('tags' => ['BCX', 'Jason'])
      end
    end

    it 'does not include the key if no tags are set' do
      logger.info('Stuff')
      is_expected.not_to have_key('tags')
    end
  end
end
