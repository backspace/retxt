require_relative '../../app/commands/unsubscribe'
require 'command_context'
require 'txts_relay_admins'

describe Unsubscribe do
  include_context 'command context'

  let(:subscriptionRepository) { double('subscription repository') }

  def execute
    Unsubscribe.new(command_context).execute
  end

  context 'when the sender is subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    it 'deletes the subscription and notifies admins' do
      subscription = double('subscription')
      relay.stub(:subscription_for).with(sender).and_return(subscription)

      subscription.should_receive(:destroy)

      I18n.should_receive('t').with('txts.goodbye').and_return('goodbye')
      SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'goodbye')

      sender.stub(:name_or_anon).and_return('name')

      I18n.should_receive('t').with('txts.admin.unsubscribed', name: sender.name_or_anon, number: sender.number).and_return('unsubscribed')
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'unsubscribed')

      execute
    end
  end

  context 'whon the sender is not subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(false)
    end

    it 'sends the not subscribed message' do
      I18n.should_receive('t').with('txts.not_subscribed').and_return('not subscribed')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'not subscribed')
      execute
    end
  end
end
