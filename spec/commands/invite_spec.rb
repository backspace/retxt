require_relative '../../app/commands/invite'
require 'command_context'

describe Invite do
  include_context 'command context'

  def execute
    Invite.new(command_context, invitation_repository: invitation_repository).execute
  end

  let(:invited_number) { '1919' }
  let(:arguments) { invited_number }
  let(:new_subscriber) { double(:new_subscriber) }

  let(:invitation_repository) { double('invitation repository') }

  context 'from an admin' do
    before do
      sender_is_admin
    end

    context 'when the number is not already subscribed' do
      before do
        allow(relay).to receive(:number_subscribed?).with(invited_number).and_return(false)
      end

      context 'when the number has never been invited' do
        before do
          allow(relay).to receive(:invited?).with(invited_number).and_return(false)
          allow(Subscriber).to receive(:new).with(hash_including(number: invited_number)).and_return(new_subscriber)
        end

        it 'invites the number' do
          expect_response_to new_subscriber, 'InviteResponse'
          expect_response_to_sender 'AdminInviteResponse'

          expect(invitation_repository).to receive(:create).with(number: invited_number, relay: relay)

          execute
        end
      end

      context 'when the number has been invited' do
        before do
          allow(relay).to receive(:invited?).with(invited_number).and_return(true)
        end

        it 'does not invite the number and tells the admin that' do
          expect_response_to_sender 'AdminInviteBounceResponse'
          execute
        end
      end
    end

    context 'when the number is already subscribed' do
      before do
        allow(relay).to receive(:number_subscribed?).with(invited_number).and_return(true)
      end

      it 'does not invite the number and tells the admin that' do
        expect_response_to_sender 'AlreadySubscribedInviteBounceResponse'
        execute
      end
    end
  end

  it 'replies with the non-admin response' do
    expect_response_to_sender 'NonAdminBounceResponse'
    expect_notification_of_admins 'NonAdminBounceNotification'
    execute
  end
end
