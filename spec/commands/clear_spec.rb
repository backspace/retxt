require_relative '../../app/commands/clear'
require 'command_context'
require 'txts_relay_admins'

describe Clear do
  include_context 'command context'

  def execute
    Clear.new(sender: sender, relay: relay).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'clears the relay' do
      nonadmin = double('nonadmin')
      relay.stub(:non_admins).and_return([nonadmin])

      subscription = double('subscription')
      relay.stub(:subscription_for).with(nonadmin).and_return(subscription)

      subscription.should_receive(:destroy)

      I18n.should_receive(:t).with('txts.admin.clear').and_return('clear')
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'clear')

      execute
    end
  end

  context 'from a non-admin' do
    it 'replies with the non-admin message' do
      I18n.stub(:t).with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
       execute
    end
  end
end
