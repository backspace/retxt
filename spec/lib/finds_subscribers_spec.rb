require 'spec_helper'

describe FindsSubscribers do
  context 'with a named subscriber' do
    let(:name) { 'alice' }
    let!(:subscriber) { Subscriber.create(name: name) }

    it "finds the subscriber by name" do
      FindsSubscribers.find("alice").should eq(subscriber)
    end

    it "finds the subscriber with an addressable name" do
      FindsSubscribers.find("@alice").should eq(subscriber)
    end

    it "finds the subscriber regardless of whitespace" do
      FindsSubscribers.find("  @alice  ").should eq(subscriber)
    end
  end

  context 'with an anon subscriber' do
    let(:number) { '2045551313' }
    let!(:subscriber) { Subscriber.create(number: number) }

    it "finds the subscriber by number" do
      FindsSubscribers.find(number).should eq(subscriber)
    end

    it "finds the subscriber by portion of number" do
      FindsSubscribers.find("5551313").should eq(subscriber)
    end
  end

  context 'with a +-numbered anon' do
    let(:number) { '+1234' }
    let!(:subscriber) { Subscriber.create(number: number) }

    it "finds the subscriber by number" do
      FindsSubscribers.find(number).should eq(subscriber)
    end
  end
end
