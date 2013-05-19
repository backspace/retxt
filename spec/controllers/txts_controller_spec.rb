require 'spec_helper'

describe TxtsController do
  let(:relay_number) { '123455' }
  let!(:relay) { Relay.create(number: relay_number) }

  context 'when the command is help' do
    let(:number) { "5551313" }
    let(:message) { 'help' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Help" do
        help = double('help')
        Help.should_receive(:new).with(sender: subscriber, relay: relay).and_return(help)
        help.should_receive(:execute)

        send_message(message)
      end
    end
  end

  context "when the command is 'subscribe'" do
    let(:number) { "5551313" }
    let(:message) { 'subscribe test' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Subscribe" do
        subscribe = double('subscribe')
        Subscribe.should_receive(:new).with(sender: subscriber, relay: relay, arguments: 'test').and_return(subscribe)
        subscribe.should_receive(:execute)

        send_message(message)
      end
    end

    context "and the sender is not subscribed" do
      it "should execute Subscribe" do
        subscriber = double('subscriber')
        Subscriber.should_receive(:new).with(number: number).and_return(subscriber)

        subscribe = double('subscribe')
        Subscribe.should_receive(:new).with(sender: subscriber, relay: relay, arguments: 'test').and_return(subscribe)
        subscribe.should_receive(:execute)

        send_message(message)
      end
    end
  end

  context "when the command is 'unsubscribe'" do
    let(:number) { "5551313" }
    let(:message) { 'unsubscribe' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Unsubscribe" do
        unsubscribe = double('unsubscribe')
        Unsubscribe.should_receive(:new).with(sender: subscriber, relay: relay).and_return(unsubscribe)
        unsubscribe.should_receive(:execute)

        send_message(message)
      end
    end
  end

  def send_message(message)
    post :incoming, From: number, Body: message, To: relay_number
  end

  context "when the command is 'freeze'" do
    let(:number) { "5551313" }
    let(:message) { '/freeze' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Freeze" do
        freeze = double('freeze')
        Freeze.should_receive(:new).with(sender: subscriber, relay: relay).and_return(freeze)
        freeze.should_receive(:execute)

        send_message(message)
      end
    end
  end

  context "when the command is 'clear'" do
    let(:number) { "5551313" }
    let(:message) { '/clear' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Clear" do
      clear = double('clear')
      Clear.should_receive(:new).with(sender: subscriber, relay: relay).and_return(clear)
      clear.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is 'thaw'" do
    let(:number) { "5551313" }
    let(:message) { '/thaw' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Thaw" do
      thaw = double('thaw')
      Thaw.should_receive(:new).with(sender: subscriber, relay: relay).and_return(thaw)
      thaw.should_receive(:execute)

      send_message(message)
    end
  end


  context "when the command is 'who'" do
    let(:number) { "5551313" }
    let(:message) { '/who' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Who" do
      who = double('thaw')
      Who.should_receive(:new).with(sender: subscriber, relay: relay).and_return(who)
      who.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/mute @bob'" do
    let(:number) { "5551313" }
    let(:target) { "@bob" }
    let(:message) { "/mute #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Mute" do
      mute = double('mute')
      Mute.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(mute)
      mute.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/unmute @bob'" do
    let(:number) { "5551313" }
    let(:target) { "@bob" }
    let(:message) { "/unmute #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Unmute" do
      unmute = double('unmute')
      Unmute.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(unmute)
      unmute.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/close'" do
    let(:number) { '5551313' }
    let(:message) { '/close' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Close" do
      close = double('close')
      Close.should_receive(:new).with(sender: subscriber, relay: relay).and_return(close)
      close.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/open'" do
    let(:number) { '5551313' }
    let(:message) { '/open' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute open" do
      open = double('open')
      Open.should_receive(:new).with(sender: subscriber, relay: relay).and_return(open)
      open.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/rename newname'" do
    let(:number) { '5551313' }
    let(:message) { "/rename #{new_relay_name}" }
    let(:new_relay_name) { 'newname' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Rename" do
      rename = double('rename')
      Rename.should_receive(:new).with(sender: subscriber, relay: relay, arguments: new_relay_name).and_return(rename)
      rename.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/delete'" do
    let(:number) { "5551313" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    let(:message) { "/delete" }

    it "should execute delete" do
      delete = double('delete')
      Delete.should_receive(:new).with(relay: relay, sender: subscriber).and_return(delete)
      delete.should_receive(:execute)

      send_message(message)
    end
  end


  context "when the command is unrecognised" do
    let(:number) { "5551313" }
    let(:message) { "/skronk" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Unknown" do
      unknown = double('unknown')
      Unknown.should_receive(:new).with(relay: relay, sender: subscriber).and_return(unknown)
      unknown.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is a direct message" do
    let(:number) { "5551313" }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      context "and the message is to a subscriber" do
        let(:recipient_name) { 'bob' }
        let!(:recipient) { Subscriber.create!(name: recipient_name) }

        let(:message) { '@bob hello there' }

        context "and the sender is not anonymous" do

          before do
            subscriber.update_attribute(:name, 'francine')
            send_message(message)
          end

          it "should render the direct message template" do
            response.should render_template('direct_message')
          end

          it "should assign the subscriber" do
            expect(assigns(:subscriber)).to eq(subscriber)
          end

          it "should assign the recipient" do
            expect(assigns(:recipient)).to eq(recipient)
          end

        end

        context "and the sender is anonymous" do
          it "should render the anon forbidden template" do
            send_message(message)
            response.should render_template('forbid_anon_direct_message')
          end
        end
      end

      context "and the sender is not anonymous" do
        before { subscriber.update_attribute(:name, 'someone') }
        context "and the message is to anon" do
          let(:recipient_name) { 'anon' }
          let!(:recipient) { Subscriber.create!(name: recipient_name) }
          let(:message) { '@anon who are you?' }

          before { send_message(message) }

          it "should render the failed direct message template" do
            response.should render_template('failed_direct_message')
          end
        end

        context "but the message recipient does not exist" do
          let(:recipient_name) { 'colleen' }
          let(:message) { '@colleen are you there?' }

          before { send_message(message) }

          it "should render the failed direct message template" do
            response.should render_template('failed_direct_message')
          end

          it "should assign the recipient" do
            expect(assigns(:recipient)).to eq('@colleen')
          end
        end
      end
    end

    context "but the sender is not subscribed" do
      it "renders the not subscribed message" do
        controller.should_receive(:render_simple_response).with('you are not subscribed').and_call_original
        send_message('@hello but what')
      end
    end
  end

  context "when there is no command" do
    let(:number) { '5551313' }
    let(:message) { "this is not a command" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Relay" do
      relay_command = double('relay command')
      RelayCommand.should_receive(:new).with(sender: subscriber, relay: relay, content: message).and_return(relay_command)
      relay_command.should_receive(:execute)

      send_message(message)
    end
  end
end
