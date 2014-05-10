require_relative '../../lib/executor'

require_relative '../../app/models/command_context'
require_relative '../../lib/parses_commands'
require_relative '../../lib/command_structure'

describe Executor do
  before do
    stub_const('Relay', double.as_null_object)
    stub_const('Subscriber', double.as_null_object)
  end

  let(:txt) { double(:txt, from: subscriber.number, to: relay.number, body: message) }

  let(:relay_number) { '123455' }
  let!(:relay) { Relay.create(number: relay_number) }

  let(:message) { 'help' }
  let(:number) { "5551313" }
  let!(:subscriber) { Subscriber.create!(number: number) }

  let(:arguments) { message.index(" ") ? message[message.index(" ") + 1..-1] : nil }
  let(:command_context) { CommandContext.new(sender: subscriber, relay: relay, originating_txt: txt, arguments: arguments) }

  def send_message(message)
    Subscriber.stub(:find_or_create_by).with(number: subscriber.number).and_return(subscriber)
    Relay.stub(:find_or_create_by).with(number: relay.number).and_return(relay)
    Executor.new(txt).execute
  end

  it 'executes the parsed command' do
    command_class = double(:command)
    parser = double(:parser)
    ParsesCommands.should_receive(:new).with(message, command_context).and_return(parser)
    parser.should_receive(:parse).and_return(command_class)

    parser.should_receive(:locale).and_return(:locale)

    command = double(:command)
    command_class.should_receive(:new).with(command_context.tap{|context| context.locale = :locale }).and_return(command)
    command.should_receive(:execute)

    send_message message
  end
end
