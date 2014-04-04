require_relative '../../app/commands/create'
require 'command_context'
require 'buys_numbers'
require 'txts_relay_admins'
require 'extracts_area_codes'


describe Create do
  include_context 'command context'

  let(:arguments) { 'newname' }
  let(:application_url) { 'application url' }

  let(:new_relay_area_code) { '212' }
  let(:new_relay_number) { '1221' }

  def execute
    Create.new(sender: sender, relay: relay, arguments: arguments, application_url: application_url).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'buys a number from the relay area code, creates a relay, and notifies admins' do
      ExtractsAreaCodes.should_receive(:new).with(relay.number).and_return(double(:extractor, extract_area_code: new_relay_area_code))
      BuysNumbers.should_receive(:buy_number).with(new_relay_area_code, application_url).and_return(new_relay_number)

      relay_repository = double('relay repository')
      stub_const('Relay', relay_repository)
      relay = double('relay', name: arguments)

      relay_repository.should_receive(:create).with(name: arguments, number: new_relay_number).and_return(relay)

      subscription_repository = double('subscription repository')
      stub_const('Subscription', subscription_repository)

      subscription_repository.should_receive(:create).with(relay: relay, subscriber: sender)

      I18n.stub(:t).with('txts.admin.create', admin_name: sender.addressable_name, relay_name: arguments).and_return('create')
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'create')

      execute
    end
  end

  it 'replies with the non-admin message' do
    I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
    SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
    execute
  end
end
