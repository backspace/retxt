require 'spec_helper'

describe TxtsController do
  let(:relay_number) { '123455' }
  let!(:relay) { Relay.create(number: relay_number) }

  context "when the command is 'help'" do
    it "renders the help message" do
      controller.should_receive(:render_to_string).with(hash_including(partial: 'commands_content'))
      post :incoming, Body: 'help'
    end
  end

  context "when the command is 'name'" do
    let(:number) { "5551313" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    context "and a new name is supplied" do
      it "changes the subscriber's name" do
        new_name = "newname"
        post :incoming, From: number, Body: "name #{new_name}"

        subscriber.reload
        subscriber.name.should == new_name
      end
    end

    it "renders the name message" do
      number = "5551313"
      controller.should_receive(:render_to_string).with(hash_including(partial: 'name'))
      post :incoming, From: number, Body: "name"
    end
  end

  context "when the command is 'subscribe'" do
    let(:number) { "5551313" }
    context "and the sender is subscribed to this relay" do
      it "renders the already-subscribed message" do
        subscriber = Subscriber.create!(number: number)
        Subscription.create(relay: relay, subscriber: subscriber)
        controller.should_receive(:render_simple_response).with('you are already subscribed').and_call_original
        post :incoming, From: number, Body: "subscribe", To: relay_number
      end
    end

    context "and the sender is subscribed to another relay" do
      before do
        other_relay = Relay.create(number: '11', name: 'X')
        subscriber = Subscriber.create!(number: number)
        Subscription.create(relay: other_relay, subscriber: subscriber)
      end

      it "subscribers the number" do
        post :incoming, From: number, Body: "subscribe", To: relay_number

        Subscriber.count.should eq(1)
        Subscription.where(relay: relay, subscriber: Subscriber.first).should be_present
      end
    end

    context "and the sender is not subscribed" do
      it "subscribes the number" do
        post :incoming, From: number, Body: "subscribe", To: relay_number

        Subscriber.first.number.should == number
        Subscription.first.relay.should == relay
      end

      context "and a name is supplied" do
        it "sets the subscriber's name" do
          name = "myname"
          post :incoming, From: number, Body: "subscribe #{name}", To: relay_number

          Subscriber.first.name.should == name
        end
      end

      it "renders the welcome message" do
        controller.should_receive(:welcome).and_call_original
        post :incoming, Body: "subscribe", To: relay_number
      end

      context "but subscriptions are closed" do
        before { relay.update_attribute(:closed, true) }
        it "should render the bounced template" do
          post :incoming, Body: "subscribe", To: relay_number
          response.should render_template('bounce_subscription')
        end
      end
    end
  end

  context "when the command is 'unsubscribe'" do
    let(:number) { "5551313" }
    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      context "to another relay" do
        let!(:other_relay) { Relay.create(number: '313') }
        let!(:subscription) { Subscription.create(subscriber: subscriber, relay: other_relay) }

        it "renders the not subscribed message" do
          controller.should_receive(:render_simple_response).with('you are not subscribed').and_call_original
          post :incoming, From: number, Body: "unsubscribe", To: relay_number
        end
      end

      context "to this relay" do
        let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

        before { post :incoming, From: number, Body: "unsubscribe", To: relay_number }
        it "destroys the subscription" do
          Subscription.deleted.should include(subscription)
        end

        it "keeps the subscriber" do
          Subscriber.all.should include(subscriber)
        end

        it "renders the goodbye message" do
          response.should render_template('goodbye_and_notification')
        end
      end
    end

    context "and the sender is not subscribed" do
      it "renders the not subscribed message" do
        controller.should_receive(:render_simple_response).with('you are not subscribed').and_call_original
        post :incoming, From: number, Body: "unsubscribe"
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
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      context "and the sender is an admin" do
        before { subscriber.update_attribute(:admin, true) }

        it "should freeze the relay" do
          send_message(message)
          relay.reload
          relay.frozen.should be_true
        end
      end

      it "should not freeze the relay" do
        send_message(message)
        relay.reload
        relay.frozen.should be_false
      end
    end
  end

  context "when the command is 'thaw'" do
    let(:number) { "5551313" }
    let(:message) { '/thaw' }

    before { relay.update_attribute(:frozen, true) }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create!(subscriber: subscriber, relay: relay) }

      context "and the sender is an admin" do
        before { subscriber.update_attribute(:admin, true) }

        it "should thaw the relay" do
          send_message(message)
          relay.reload
          relay.frozen.should be_false
        end
      end

      it "should not thaw the relay" do
        send_message(message)
        relay.reload
        relay.frozen.should be_true
      end
    end
  end

  context "when the command is '/who'" do
    let(:number) { "5551313" }
    let(:message) { '/who' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      let!(:other_subscriber_1) { Subscriber.create }
      let!(:other_subscriber_2) { Subscriber.create }

      let!(:other_subscription_1) { Subscription.create(subscriber: other_subscriber_1, relay: relay) }
      let!(:other_subscription_2) { Subscription.create(subscriber: other_subscriber_2, relay: relay) }

      let!(:other_relay) { Relay.create }
      let!(:other_relay_subscriber) { Subscriber.create }
      let!(:other_relay_subscription) { Subscription.create(subscriber: other_relay_subscriber, relay: other_relay) }

      it 'should render a non-admin response' do
        controller.should_receive(:render_simple_response).with('you are not an admin').and_call_original
        send_message(message)
      end

      context "and the sender is an admin" do
        before do
          subscriber.update_attribute(:admin, true)

          send_message(message)
        end

        it "should render the who template" do
          response.should render_template('who')
        end

        it "should assign the subscribers" do
          expect(assigns(:subscribers)).to include(subscriber, other_subscriber_1, other_subscriber_2)
          assigns(:subscribers).should_not include(other_relay_subscriber)
        end
      end
    end
  end

  context "when the command is '/mute'" do
    context "and the sender is subscribed and an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      before { subscriber.update_attribute(:admin, true) }

      context "and the target is subscribed" do
        let(:mutee_name) { "bob" }
        let!(:mutee) { Subscriber.create(number: Time.now.to_f, name: mutee_name) }
        let!(:mutee_subscription) { Subscription.create(subscriber: mutee, relay: relay) }

        let(:message) { "/mute @#{mutee_name}" }

        before { send_message(message) }

        it "should render the muted template" do
          response.should render_template('muted')
        end

        it "should assign the muted" do
          assigns(:mutee).should eq(mutee)
        end

        it "should mute the mutee" do
          mutee_subscription.reload
          mutee_subscription.muted.should be_true
        end
      end
    end
  end

  context "when the command is '/unmute'" do
    context "and the sender is subscribed and an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      before { subscriber.update_attribute(:admin, true) }

      context "and the target is subscribed and muted" do
        let(:unmutee_name) { "bob" }
        let!(:unmutee) { Subscriber.create(number: Time.now.to_f, name: unmutee_name) }
        let!(:unmutee_subscription) { Subscription.create(subscriber: unmutee, relay: relay, muted: true) }

        let(:message) { "/unmute @#{unmutee_name}" }

        before { send_message(message) }

        it "should render the unmuted template" do
          response.should render_template('unmuted')
        end

        it "should assign the unmuted" do
          assigns(:unmutee).should eq(unmutee)
        end

        it "should unmute the unmutee" do
          unmutee_subscription.reload
          unmutee_subscription.muted.should be_false
        end
      end
    end
  end

  context "when the command is '/close'" do
    context "and the sender is subscribed an an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      before { subscriber.update_attribute(:admin, true) }

      let(:message) { "/close" }

      before { send_message(message) }

      it "should render the closed template" do
        response.should render_template('closed')
      end

      it "should close the relay" do
        relay.reload
        relay.closed.should be_true
      end
    end
  end

  context "when the command is '/open' and the relay is closed" do
    before { relay.update_attribute(:closed, true) }

    context "and the sender is subscribed an an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      before { subscriber.update_attribute(:admin, true) }

      let(:message) { "/open" }

      before { send_message(message) }

      it "should render the opened template" do
        response.should render_template('opened')
      end

      it "should open the relay" do
        relay.reload
        relay.closed.should be_false
      end
    end
  end

  context "when the command is '/rename (name)'" do
    context "and the sender is subscribed as an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      let(:new_relay_name) { "newname" }

      let(:message) { "/rename #{new_relay_name}" }

      before do
        subscriber.update_attribute(:admin, true)
        send_message(message)
      end

      it "should render the renamed template" do
        response.should render_template('renamed')
      end

      it "should rename the relay" do
        relay.reload
        relay.name.should eq(new_relay_name)
      end
    end
  end

  context "when the command is '/clear'" do
    context "and another person is subscribed" do
      let!(:other_subscriber) { Subscriber.create!(number: "1234") }
      let!(:other_subscription) { Subscription.create(subscriber: other_subscriber, relay: relay) }

      context "and the sender is subscribed as an admin" do
        let(:number) { "5551313" }
        let!(:subscriber) { Subscriber.create!(number: number) }
        let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

        let(:message) { "/clear" }

        before do
          subscriber.update_attribute(:admin, true)
          send_message(message)
        end

        it "should render the renamed template" do
          response.should render_template('cleared')
        end

        it "should clear the relay of everyone but the sender" do
          relay.reload
          relay.subscribed?(other_subscriber).should be_false
          relay.subscribed?(subscriber).should be_true
        end
      end
    end
  end

  context "when the command is '/delete'" do
    context "and the sender is subscribed as an admin" do
      let(:number) { "5551313" }
      let!(:subscriber) { Subscriber.create!(number: number) }
      let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }

      let(:message) { "/delete" }

      before do
        subscriber.update_attribute(:admin, true)
      end

      it "should delegate to DeletesRelays" do
        DeletesRelays.should_receive(:delete_relay).with(subscriber: subscriber, relay: relay)
        send_message(message)
      end
    end
  end


  context "when the command is unrecognised" do
    let(:number) { "5551313" }
    let(:message) { "/skronk" }

    before { send_message(message) }

    it "should render the unknown command template" do
      response.should render_template('unknown_command')
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
    let(:number) { "5551313" }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      let(:other_number) { "5551212" }
      let!(:other_subscriber) { Subscriber.create!(number: other_number) }
      let!(:other_subscription) { Subscription.create(relay: relay, subscriber: other_subscriber) }

      context "to another relay" do
        let!(:other_relay) { Relay.create(number: "66116") }
        let!(:other_relay_subscription) { Subscription.create(relay: other_relay, subscriber: subscriber) }

        it "renders the not subscribed message" do
          controller.should_receive(:render_simple_response).with('you are not subscribed').and_call_original
          post :incoming, From: number, Body: "this is not a command", To: relay_number
        end
      end

      context "to this relay" do
        let!(:subscription) { Subscription.create(subscriber: subscriber, relay: relay) }
        let(:message) { "this is not a command" }

        def send_message
          post :incoming, From: number, Body: message, To: relay_number
        end

        it "relays to everyone but the sender" do
          send_message
          expect(assigns(:destinations)).to eq([other_number])
        end

        it "renders the relay view" do
          send_message
          response.should render_template('relay')
        end

        context "but the list is frozen" do
          it "does not relay the message" do
            relay.update_attribute(:frozen, true)
            controller.should_receive(:render_simple_response).with('the relay is frozen').and_call_original
            post :incoming, From: number, Body: "this is a relay message", To: relay_number
            response.should_not render_template('relay')
          end
        end

        context "but the subscriber is muted and an admin exists" do
          let(:admin_number) { '12333' }
          let(:admin) { Subscriber.create(name: 'admin', number: admin_number) }
          let!(:admin_subscription) { Subscription.create(subscriber: admin, relay: relay) }

          before do
            admin.update_attribute(:admin, true)
            subscription.update_attribute(:muted, true)
            send_message
          end

          it "should render the direct message template" do
            response.should render_template('muted_relay_fail')
          end

          it "should assign the original message" do
            expect(assigns(:original_message)).to eq(message)
          end

          it "should assign the admin numbers" do
            assigns(:admin_destinations).should include(admin_number)
          end

          it "should assign the mutee" do
            assigns(:mutee).should eq(subscriber)
          end
        end
      end
    end

    context "and the sender is not subscribed" do
      it "renders the not subscribed message" do
        controller.should_receive(:render_simple_response).with('you are not subscribed').and_call_original
        post :incoming, From: number, Body: "this is not a command"
      end
    end
  end
end
