require 'spec_helper'

describe TxtsController do
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
    context "and the sender is subscribed" do
      it "renders the already-subscribed message" do
        Subscriber.create!(number: number)
        controller.should_receive(:render_simple_response).with('you are already subscribed').and_call_original
        post :incoming, From: number, Body: "subscribe"
      end
    end

    context "and the sender is not subscribed" do
      it "subscribes the number" do
        post :incoming, From: number, Body: "subscribe"

        Subscriber.first.number.should == number
      end

      context "and a name is supplied" do
        it "sets the subscriber's name" do
          name = "myname"
          post :incoming, From: number, Body: "subscribe #{name}"

          Subscriber.first.name.should == name
        end
      end

      it "renders the welcome message" do
        controller.should_receive(:welcome).and_call_original
        post :incoming, Body: "subscribe"
      end
    end
  end

  context "when the command is 'unsubscribe'" do
    let(:number) { "5551313" }
    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      before { post :incoming, From: number, Body: "unsubscribe" }
      it "unsubscribes the number" do
        Subscriber.all.should be_empty
      end

      it "renders the goodbye message" do
        response.should render_template('goodbye_and_notification')
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
    post :incoming, From: number, Body: message
  end

  context "when the command is 'freeze'" do
    let(:number) { "5551313" }
    let(:message) { 'freeze' }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      context "and the sender is an admin" do
        before { subscriber.update_attribute(:admin, true) }

        it "should freeze the relay" do
          send_message(message)
          RelaySettings.frozen.should be_true
        end
      end

      it "should not freeze the relay" do
        send_message(message)
        RelaySettings.frozen.should be_false
      end
    end
  end

  context "when the command is 'thaw'" do
    let(:number) { "5551313" }
    let(:message) { 'thaw' }

    before { RelaySettings.frozen = true }

    context "and the sender is subscribed" do
      let!(:subscriber) { Subscriber.create!(number: number) }

      context "and the sender is an admin" do
        before { subscriber.update_attribute(:admin, true) }

        it "should thaw the relay" do
          send_message(message)
          RelaySettings.frozen.should be_false
        end
      end

      it "should not thaw the relay" do
        send_message(message)
        RelaySettings.frozen.should be_true
      end
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

        before { send_message(message) }

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

      before { post :incoming, From: number, Body: "this is not a command" }

      it "relays to everyone but the sender" do
        expect(assigns(:destinations)).to eq([other_number])
      end

      it "renders the relay view" do
        response.should render_template('relay')
      end

      context "but the list is frozen" do
        it "does not relay the message" do
          RelaySettings.frozen = true
          controller.should_receive(:render_simple_response).with('the relay is frozen').and_call_original
          post :incoming, From: number, Body: "this is a relay message"
          response.should_not render_template('relay')
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
