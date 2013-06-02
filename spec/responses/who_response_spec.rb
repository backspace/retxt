require_relative '../../app/responses/who_response'

describe WhoResponse do
  let(:anon) { double('anon', admin: false, number: '1', addressable_name: 'anon') }
  let(:admin) { double('admin', admin: true, number: '2', addressable_name: '@admin') }
  let(:muted) { double('muted', admin: false, number: '3', addressable_name: 'muted') }
  let(:voiced) { double('voiced', admin: false, number: '4', addressable_name: 'voiced') }

  let(:subscribers) { [admin, anon, muted, voiced] }
  let(:relay) { double('relay', subscribers: subscribers) }

  before do
    regular_subscription = double('subscription', muted: false, voiced: false)

    relay.stub(:subscription_for).with(admin).and_return(regular_subscription)
    relay.stub(:subscription_for).with(anon).and_return(regular_subscription)

    muted_subscription = double('muted subscription', muted: true, voiced: false)
    relay.stub(:subscription_for).with(muted).and_return(muted_subscription)

    voiced_subscription = double('voiced subscription', muted:false, voiced: true)
    relay.stub(:subscription_for).with(voiced).and_return(voiced_subscription)
  end

  it 'generates a who response' do
    response = WhoResponse.generate(relay: relay)
    response.should include("anon 1\n")
    response.should include('@admin* 2')
    response.should include("muted (muted) 3")
    response.should include("voiced (voiced) 4")
  end
end
