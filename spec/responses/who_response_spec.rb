require_relative '../../app/responses/who_response'

describe WhoResponse do
  let(:anon) { double('anon', admin: false, number: '1', addressable_name: 'anon') }
  let(:admin) { double('admin', admin: true, number: '2', addressable_name: '@admin') }
  let(:subscribers) { [admin, anon] }
  let(:relay) { double('relay', subscribers: subscribers) }

  it 'generates a who response' do
    response = WhoResponse.generate(relay: relay)
    response.should include("anon 1\n")
    response.should include('@admin* 2')
  end
end
