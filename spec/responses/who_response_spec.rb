require_relative '../../app/responses/simple_response'
require_relative '../../app/responses/who_response'

describe WhoResponse do
  let(:anon) { double('anon', admin: false, number: '1', addressable_name: 'anon') }
  let(:admin) { double('admin', admin: true, number: '2', addressable_name: '@admin') }
  let(:muted) { double('muted', admin: false, number: '3', addressable_name: 'muted') }
  let(:voiced) { double('voiced', admin: false, number: '4', addressable_name: 'voiced') }

  let(:admin_subscription) { double('admin_subscription', subscriber: admin, created_at: 1, muted: false, voiced: false) }
  let(:muted_subscription) { double('muted_subscription', subscriber: muted, created_at: 2, muted: true, voiced: false) }
  let(:anon_subscription) { double('anon_subscription', subscriber: anon, created_at: 3, muted: false, voiced: false) }
  let(:voiced_subscription) { double('voiced_subscription', subscriber: voiced, created_at: 4, muted: false, voiced: true) }

  let(:subscriptions) { [anon_subscription, admin_subscription, muted_subscription, voiced_subscription] }
  let(:relay) { double('relay', subscriptions: subscriptions) }

  it 'generates a who response' do
    response = WhoResponse.new(double(:context, relay: relay))
    expect(response.body).to include("@admin* 2\nmuted (muted) 3\nanon 1\nvoiced (voiced) 4")
  end
end
