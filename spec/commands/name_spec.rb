require_relative '../../app/commands/name'
require 'command_context'

require_relative '../../lib/changes_names'

describe Name do
  include_context 'command context'
  let(:arguments) { 'newname' }

  def execute
    Name.new(command_context).execute
  end

  context 'when the sender is subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(true)
    end

    it 'changes the sender name and sends a confirmation' do
      expect(ChangesNames).to receive(:change_name).with(sender, arguments)
      expect_response_to_sender 'NameResponse'
      execute
    end
  end
end
