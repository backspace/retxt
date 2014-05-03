require_relative '../../app/commands/modify_subscription'
require 'finds_subscribers'
require 'command_context'

describe ModifySubscription do

  include_context 'command context'

  let(:arguments) { '@user' }
  let(:success_message) { 'success!' }
  let(:modifier) { lambda{} }

  let(:finds_subscribers) { double('finds_subscribers') }

  before do
    stub_const('FindsSubscribers', finds_subscribers)
  end

  def execute
    ModifySubscription.new(command_context, modifier: modifier, success_message: success_message).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    context 'and the target exists' do
      let(:target) { double('target') }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(target)
      end

      context 'and is subscribed' do
        let(:subscription) { double('subscription').as_null_object }

        before do
          relay.stub(:subscription_for).with(target).and_return(subscription)
        end

        it 'calls the modifier with the subscription' do
          modifier.should_receive(:call).with(subscription)
          execute
        end

        it 'notifies all admins of the change' do
          modifier.stub(:call)
          TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: success_message)
          execute
        end
      end

      before do
        relay.stub(:subscription_for).with(target).and_return(nil)
      end

      it 'replies with the unsubscribed target message' do
        I18n.should_receive('t').with('txts.unsubscribed_target', target: arguments).and_return('unsubscribed')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unsubscribed')
        execute
      end
    end

    before do
      finds_subscribers.stub(:find).with(arguments).and_return(nil)
    end

    it 'replies with the missing target message' do
      I18n.should_receive('t').with('txts.missing_target', target: arguments).and_return('missing')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'missing')
      execute
    end
  end

  it 'replies with the non-admin message' do
    I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
    SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
    execute
  end
end
