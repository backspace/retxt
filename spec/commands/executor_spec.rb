require_relative '../../app/commands/executor'

require_relative '../../app/commands/admin'
require_relative '../../app/commands/clear'
require_relative '../../app/commands/close'
require_relative '../../app/commands/create'
require_relative '../../app/commands/delete'
require_relative '../../app/commands/direct_message'
require_relative '../../app/commands/freeze'
require_relative '../../app/commands/help'
require_relative '../../app/commands/moderate'
require_relative '../../app/commands/mute'
require_relative '../../app/commands/open'
require_relative '../../app/commands/relay_command'
require_relative '../../app/commands/rename'
require_relative '../../app/commands/subscribe'
require_relative '../../app/commands/thaw'
require_relative '../../app/commands/timestamp'
require_relative '../../app/commands/unadmin'
require_relative '../../app/commands/unknown'
require_relative '../../app/commands/unmoderate'
require_relative '../../app/commands/unmute'
require_relative '../../app/commands/unsubscribe'
require_relative '../../app/commands/unvoice'
require_relative '../../app/commands/voice'
require_relative '../../app/commands/who'

describe Executor do
  before do
    stub_const('Relay', double.as_null_object)
    stub_const('Subscriber', double.as_null_object)
  end

  let(:txt) { double(:txt, from: subscriber.number, to: relay.number, body: message) }

  let(:relay_number) { '123455' }
  let!(:relay) { Relay.create(number: relay_number) }

  def send_message(message)
    Subscriber.stub(:find_or_create_by).with(number: subscriber.number).and_return(subscriber)
    Relay.stub(:find_or_create_by).with(number: relay.number).and_return(relay)
    Executor.new(txt).execute
  end

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
      let(:subscriber) { Subscriber.create!(number: number) }
      it "should execute Subscribe" do
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

  context "when the command is 'moderate'" do
    let(:number) { "5551313" }
    let(:message) { '/moderate' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Moderate" do
        moderate = double('moderate')
        Moderate.should_receive(:new).with(sender: subscriber, relay: relay).and_return(moderate)
        moderate.should_receive(:execute)

        send_message(message)
      end
    end
  end

  context "when the command is 'unmoderate'" do
    let(:number) { "5551313" }
    let(:message) { '/unmoderate' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      it "should execute Unmoderate" do
        unmoderate = double('unmoderate')
        Unmoderate.should_receive(:new).with(sender: subscriber, relay: relay).and_return(unmoderate)
        unmoderate.should_receive(:execute)

        send_message(message)
      end
    end
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

  context "when the command is 'create relay'" do
    let(:number) { "5551313" }
    let(:message) { "/create relay" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Create" do
      create = double('create')
      Create.should_receive(:new).with(sender: subscriber, relay: relay, application_url: nil, arguments: 'relay').and_return(create)
      create.should_receive(:execute)

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

  context "when the command is '/voice @bob'" do
    let(:number) { "5551313" }
    let(:target) { "@bob" }
    let(:message) { "/voice #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Voice" do
      voice = double('voice')
      Voice.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(voice)
      voice.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/unvoice @bob'" do
    let(:number) { "5551313" }
    let(:target) { "@bob" }
    let(:message) { "/unvoice #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Unvoice" do
      unvoice = double('unvoice')
      Unvoice.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(unvoice)
      unvoice.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/admin @alice'" do
    let(:number) { '5551313' }
    let(:target) { '@alice' }
    let(:message) { "/admin #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Admin" do
      admin = double('admin')
      Admin.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(admin)
      admin.should_receive(:execute)

      send_message(message)
    end
  end

  context "when the command is '/unadmin @alice'" do
    let(:number) { '5551313' }
    let(:target) { '@alice' }
    let(:message) { "/unadmin #{target}" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Unadmin" do
      unadmin = double('unadmin')
      Unadmin.should_receive(:new).with(sender: subscriber, relay: relay, arguments: target).and_return(unadmin)
      unadmin.should_receive(:execute)

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

  context "when the command is '/timestamp'" do
    let(:number) { '5551313' }
    let!(:subscriber) { Subscriber.create!(number: number) }

    context "with no parameters" do
      let(:message) { "/timestamp" }

      it "should execute Timestamp with no arguments" do
        timestamp = double('timestamp')
        Timestamp.should_receive(:new).with(sender: subscriber, relay: relay, arguments: "").and_return(timestamp)
        timestamp.should_receive :execute

        send_message(message)
      end
    end

    context "with a timestamp argument" do
      let(:argument) { 'strftime' }
      let(:message) { "/timestamp #{argument}" }

      it "should execute Timestamp with the format string" do
        timestamp = double('timestamp')
        Timestamp.should_receive(:new).with(sender: subscriber, relay: relay, arguments: argument).and_return(timestamp)
        timestamp.should_receive :execute

        send_message(message)
      end
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
    let(:message) { "@hello user" }

    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute DirectMessage" do
      direct = double('direct')
      DirectMessage.should_receive(:new).with(relay: relay, sender: subscriber, txt: txt).and_return(direct)
      direct.should_receive(:execute)

      send_message(message)
    end
  end

  context "when there is no command" do
    let(:number) { '5551313' }
    let(:message) { "this is not a command" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    it "should execute Relay" do
      relay_command = double('relay command')
      RelayCommand.should_receive(:new).with(sender: subscriber, relay: relay, txt: txt).and_return(relay_command)
      relay_command.should_receive(:execute)

      send_message(message)
    end
  end
end
