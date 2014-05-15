require_relative '../../app/commands/who'
require 'command_context'

describe Who do
  include_context 'command context'

  let(:who_txt) { double('who_txt') }
  let(:who_txt_content) { ['a who!', 'another who'] }

  def execute
    Who.new(command_context).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'replies with the who txt' do
      expect_response_to_sender 'WhoResponse'
      execute
    end
  end

  it 'replies with the non-admin response' do
    expect_response_to_sender 'NonAdminBounceResponse'
    execute
  end
end
