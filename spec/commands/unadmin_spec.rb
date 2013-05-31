require_relative '../../app/commands/unadmin'
require 'command_context'

require 'txts_relay_admins'

describe Unadmin do
  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  before do
    stub_const('FindsSubscribers', finds_subscribers)
  end

  def execute
    Unadmin.new(sender: sender, relay: relay, arguments: arguments, finds_subscribers: finds_subscribers).execute
  end

  context 'the sender is an admin' do
    before do
      sender_is_admin
    end

    context 'when the unadminee exists' do
      let(:unadminee) { double('unadminee').as_null_object }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(unadminee)
      end

      it 'makes the unadminee an non-admin' do
        unadminee.should_receive(:unadmin!)
        execute
      end

      it 'tells all admins' do
        I18n.stub('t').with('txts.admin.unadmin', unadminer_name: sender.addressable_name, unadminee_name: unadminee.addressable_name).and_return('unadmined')

        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'unadmined')

        execute
      end
    end

    before do
      finds_subscribers.stub(:find).with(arguments).and_return(nil)
    end

    it 'repiles with the missing target message' do
      I18n.should_receive('t').with('txts.missing_target', target: arguments).and_return('missing')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'missing')
      execute
    end
  end

  context 'from a non-admin' do
    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end

