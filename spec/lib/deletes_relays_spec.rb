require 'deletes_relays'

describe DeletesRelays do
  let(:relay_number) { "5551313" }
  let(:relay_name) { "dying" }
  let(:relay) { double(:relay, number: relay_number, name: relay_name).as_null_object }

  let(:substitute_relay_number) { "1234" }

  let(:subscriber_number) { "5551212" }
  let(:subscriber) { double(:subscriber, number: subscriber_number) }

  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:incoming_phone_numbers) { double('incoming_phone_numbers') }
  let(:phone_number_list) { double('list') }
  let(:phone_number) { double('phone_number').as_null_object }

  let(:messages) { double('messages').as_null_object }
  let(:sms) { double('sms') }

  before do
    allow(client).to receive(:account).and_return(account)
    allow(account).to receive(:incoming_phone_numbers).and_return(incoming_phone_numbers)
    allow(incoming_phone_numbers).to receive(:list).and_return(phone_number_list)
    allow(phone_number_list).to receive(:first).and_return(phone_number)

    allow(account).to receive(:sms).and_return(sms)
    allow(sms).to receive(:messages).and_return(messages)
  end

  def call_method
    DeletesRelays.delete_relay(relay: relay, client: client, subscriber: subscriber, substitute_relay_number: substitute_relay_number)
  end

  it 'should trigger API calls to delete the relay number' do
    expect(phone_number).to receive :delete
    call_method
  end

  it 'should destroy the relay' do
    expect(relay).to receive :destroy
    call_method
  end
end
