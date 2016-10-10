require_relative '../../app/commands/invite'
require 'command_context'

describe Invite do
  include_context 'command context'

  def execute
    Invite.new(command_context).execute
  end

  let(:invited_number) { '1919' }
  let(:arguments) { invited_number }
  let(:new_subscriber) { double(:new_subscriber) }

  before do
    allow(Subscriber).to receive(:new).with(hash_including(number: invited_number)).and_return(new_subscriber)
  end

  it 'invites the number' do
    expect_response_to new_subscriber, 'InviteResponse'
    expect_response_to_sender 'AdminInviteResponse'

    execute
  end
end
