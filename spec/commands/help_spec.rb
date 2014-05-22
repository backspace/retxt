require_relative '../../app/commands/help'
require 'command_context'

require_relative '../../app/responses/simple_response'
require_relative '../../app/responses/command_help_response'

describe Help do
  include_context 'command context'

  def execute
    Help.new(command_context).execute
  end

  it 'replies with the help message' do
    expect_response_to_sender 'HelpResponse'
    execute
  end

  context 'when sender is an admin' do
    before do
      sender_is_admin
    end

    it 'replies with the regular and admin help messages' do
      expect_response_to_sender 'HelpResponse'
      expect_response_to_sender 'AdminHelpResponse'
      execute
    end
  end

  context 'when there is a command argument' do
    let(:arguments) { 'command' }

    it 'replies with help for the command' do
      expect_response_to_sender 'CommandHelpResponse'
      execute
    end
  end
end
