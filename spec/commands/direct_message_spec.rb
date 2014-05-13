require_relative '../../app/commands/direct_message'
require 'command_context'
require 'finds_subscribers'
require 'timestamp_formatter'

describe DirectMessage do
  include_context 'command context'

  let(:txt) { double(:txt, body: content, id: 'def') }
  let(:content) { '@user hello' }

  def execute
    DirectMessage.new(command_context).execute
  end

  context 'when the sender exists' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    context 'and is not anonymous' do
      before do
        sender.stub(:anonymous?).and_return(false)
        sender.stub(:addressable_name).and_return("@sender")
      end

      context 'and the target exists' do
        let(:target) { double('target', number: '5555') }
        let(:timestamp) { double(:formatter, format: 'timestamp ') }

        before do
          FindsSubscribers.stub(:find).with('@user').and_return(target)
        end

        it 'sends the message and replies' do
          expect_response_to target, 'OutgoingDirectMessageResponse'
          expect_response_to_sender 'SentDirectMessageResponse'

          execute
        end
      end

      context 'and the target does not exist' do
        before do
          FindsSubscribers.stub(:find).with('@user').and_return(nil)
        end

        it 'sends the failed message' do
          expect_response_to_sender 'MissingDirectMessageTargetResponse'

          execute
        end
      end
    end

    context 'and is anonymous' do
      before do
        sender.stub(:anonymous?).and_return(true)
      end

      it 'forbids the message' do
        expect_response_to_sender 'ForbiddenAnonymousDirectMessageResponse'
        execute
      end
    end
  end
end
