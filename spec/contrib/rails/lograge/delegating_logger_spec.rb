require 'dog_collar'

describe DogCollar::Contrib::Rails::Lograge::DelegatingLogger do
  let(:logger) { double }
  let(:data) {
    {
      method: 'GET',
      path: '/users',
      status: 200,
      controller: 'UserController',
      action: 'index',
      format: 'json',
    }
  }

  subject{ described_class.new(logger) }

  it 'formats the message before delegating to the underlying logger' do
    message = 'GET /users (200) -> UserController#index.json'
    expect(logger).to receive(:debug).with(message, data)
    subject.send(:debug, data)
  end
end
