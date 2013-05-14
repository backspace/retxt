require 'deletes_relays'

describe DeletesRelays do
  let(:relay_number) { "5551313" }
  let(:relay_name) { "dying" }
  let(:relay) { stub(:relay, number: relay_number, name: relay_name).as_null_object }

  let(:substitute_relay_number) { "1234" }

  let(:subscriber_number) { "5551212" }
  let(:subscriber) { stub(:subscriber, number: subscriber_number) }

  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:incoming_phone_numbers) { double('incoming_phone_numbers') }
  let(:phone_number_list) { double('list') }
  let(:phone_number) { double('phone_number').as_null_object }

  let(:messages) { double('messages').as_null_object }
  let(:sms) { double('sms') }

  before do
    client.stub(:account).and_return(account)
    account.stub(:incoming_phone_numbers).and_return(incoming_phone_numbers)
    incoming_phone_numbers.stub(:list).and_return(phone_number_list)
    phone_number_list.stub(:first).and_return(phone_number)

    account.stub(:sms).and_return(sms)
    sms.stub(:messages).and_return(messages)
  end

  def call_method
    DeletesRelays.delete_relay(relay: relay, client: client, subscriber: subscriber, substitute_relay_number: substitute_relay_number)
  end

  it 'should trigger API calls to delete the relay number' do
    phone_number.should_receive :delete
    call_method
  end

  it 'should destroy the relay' do
    relay.should_receive :destroy
    call_method
  end

  it 'should send the subscriber a success message' do
    messages.should_receive(:create).with(from: substitute_relay_number, to: subscriber_number, body: "the relay #{relay_name} was deleted")
    call_method
  end
end
