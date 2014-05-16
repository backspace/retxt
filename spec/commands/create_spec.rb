require_relative '../../app/commands/create'
require 'command_context'
require 'buys_numbers'
require 'extracts_area_codes'


describe Create do
  include_context 'command context'

  let(:arguments) { 'newname' }

  let(:new_relay_area_code) { '212' }
  let(:new_relay_number) { '1221' }

  def execute
    Create.new(command_context).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'buys a number from the relay area code, creates a relay, and notifies admins' do
      ExtractsAreaCodes.should_receive(:new).with(relay.number).and_return(double(:extractor, extract_area_code: new_relay_area_code))
      BuysNumbers.should_receive(:buy_number).with(new_relay_area_code, command_context.application_url).and_return(new_relay_number)

      relay_repository = double('relay repository')
      stub_const('Relay', relay_repository)
      relay = double('relay', name: arguments)

      relay_repository.should_receive(:create).with(name: arguments, number: new_relay_number).and_return(relay)

      subscription_repository = double('subscription repository')
      stub_const('Subscription', subscription_repository)

      subscription_repository.should_receive(:create).with(relay: relay, subscriber: sender)

      relay.should_receive(:admins).and_return(new_relay_admins = double)
      expect_notification_of new_relay_admins, 'CreationNotification'

      execute
    end
  end

  it 'replies with the non-admin message' do
    expect_response_to_sender 'NonAdminBounceResponse'
    expect_notification_of_admins 'NonAdminBounceNotification'
    execute
  end
end
