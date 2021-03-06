require_relative '../../app/commands/modify_subscription'
require 'finds_subscribers'
require 'command_context'

describe ModifySubscription do

  include_context 'command context'

  let(:arguments) { '@user' }
  let(:success_response) { double }
  let(:modifier) { lambda{} }

  let(:finds_subscribers) { double('finds_subscribers') }

  before do
    stub_const('FindsSubscribers', finds_subscribers)
  end

  def execute
    ModifySubscription.new(command_context, modifier: modifier, success_response: success_response).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    context 'and the target exists' do
      let(:target) { double('target') }

      before do
        allow(finds_subscribers).to receive(:find).with(arguments).and_return(target)
      end

      context 'and is subscribed' do
        let(:subscription) { double('subscription').as_null_object }

        before do
          allow(relay).to receive(:subscription_for).with(target).and_return(subscription)
        end

        it 'calls the modifier with the subscription and delivers the response' do
          expect(modifier).to receive(:call).with(subscription)
          expect(success_response).to receive(:deliver).with(relay.admins)
          execute
        end
      end

      before do
        allow(relay).to receive(:subscription_for).with(target).and_return(nil)
      end

      it 'replies with the unsubscribed target message' do
        expect_response_to_sender 'UnsubscribedTargetResponse'
        execute
      end
    end

    before do
      allow(finds_subscribers).to receive(:find).with(arguments).and_return(nil)
    end

    it 'replies with the missing target message' do
      expect_response_to_sender 'MissingTargetBounceResponse'
      execute
    end
  end

  it 'replies with the non-admin message' do
    expect_response_to_sender 'NonAdminBounceResponse'
    expect_notification_of_admins 'NonAdminBounceNotification'
    execute
  end
end
