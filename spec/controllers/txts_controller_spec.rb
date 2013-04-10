require 'spec_helper'

describe TxtsController do
  context "when the command is 'help'" do
    it "renders the help message" do
      controller.should_receive(:render_to_string).with(hash_including(partial: 'commands_content'))
      post :incoming, Body: 'help'
    end
  end

  context "when the command is 'nick'" do
    let(:number) { "5551313" }
    let!(:subscriber) { Subscriber.create!(number: number) }

    context "and a new nick is supplied" do
      it "changes the subscriber's nick" do
        new_nick = "newnick"
        post :incoming, From: number, Body: "nick #{new_nick}"

        subscriber.reload
        subscriber.nick.should == new_nick
      end
    end

    it "renders the nick message" do
      number = "5551313"
      controller.should_receive(:render_to_string).with(hash_including(partial: 'nick'))
      post :incoming, From: number, Body: "nick"
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

      context "and a nick is supplied" do
        it "sets the subscriber's nick" do
          nick = "mynick"
          post :incoming, From: number, Body: "subscribe #{nick}"

          Subscriber.first.nick.should == nick
        end
      end

      it "renders the welcome message" do
        controller.should_receive(:welcome).and_call_original
        post :incoming, Body: "subscribe"
      end
    end
  end

  context "when the command is 'unsubscribe'" do
    context "and the sender is subscribed" do
      it "unsubscribes the number"
      it "renders the goodbye message"
    end

    context "and the sender is not subscribed" do
      it "renders the not subscribed message"
    end
  end

  context "when there is no command" do
    context "and the sender is subscribed" do
      it "relays to everyone but the sender"
      it "renders the relay view"
    end

    context "and the sender is not subscribed" do
      it "renders the not subscribed message"
    end
  end
end
