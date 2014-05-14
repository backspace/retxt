require_relative '../../app/commands/unknown'
require 'command_context'

describe Unknown do
  include_context 'command context'

  def execute
    Unknown.new(command_context).execute
  end

  it 'replies with the rename message' do
    expect_response_to_sender 'UnknownResponse'
    execute
  end
end
