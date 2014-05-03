require_relative '../../app/commands/delete'
require 'command_context'
require 'txts_relay_admins'
require 'deletes_relays'

describe Delete do
  include_context 'command context'

  def execute
    Delete.new(command_context).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'notifies admins and deletes the relay' do
      I18n.stub(:t).with('txts.admin.delete', admin_name: sender.addressable_name).and_return('delete')
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'delete')

      DeletesRelays.should_receive(:delete_relay).with(relay: relay)

      execute
    end
  end

  context 'from a non-admin' do
    it 'does not rename the relay' do
      relay.should_not_receive(:rename!)
      execute
    end

    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin', originating_txt_id: command_context.originating_txt_id)
      execute
    end
  end
end
