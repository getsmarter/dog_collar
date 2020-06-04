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
        is_expected.to include('BCX' => 'BCX', 'Jason' => 'Jason')
      end
    end

    context 'when not given a block' do
      it 'includes the tags as metadata' do
        logger.tagged('BCX').tagged('Jason').info('Stuff')
        is_expected.to include('BCX' => 'BCX', 'Jason' => 'Jason')
      end
    end
  end
end

