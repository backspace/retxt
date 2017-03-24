require 'spec_helper'

describe FindsSubscribers do
  context 'with a named subscriber' do
    let(:name) { 'alice' }
    let!(:subscriber) { Subscriber.create(name: name) }
    let!(:blank_subscriber) { Subscriber.create() }

    it "finds the subscriber by name" do
      expect(FindsSubscribers.find("alice")).to eq(subscriber)
    end

    it "finds the subscriber with an addressable name" do
      expect(FindsSubscribers.find("@alice")).to eq(subscriber)
    end

    it "finds the subscriber regardless of whitespace" do
      expect(FindsSubscribers.find("  @alice  ")).to eq(subscriber)
    end

    it "finds the subscriber regardless of capitalisation" do
      expect(FindsSubscribers.find("@ALICe")).to eq(subscriber)
    end
  end

  context 'with an anon subscriber' do
    let(:number) { '2045551313' }
    let!(:subscriber) { Subscriber.create(number: number) }

    it "finds the subscriber by number" do
      expect(FindsSubscribers.find(number)).to eq(subscriber)
    end

    it "finds the subscriber by portion of number" do
      expect(FindsSubscribers.find("5551313")).to eq(subscriber)
    end
  end

  context 'with a +-numbered anon' do
    let(:number) { '+1234' }
    let!(:subscriber) { Subscriber.create(number: number) }

    it "finds the subscriber by number" do
      expect(FindsSubscribers.find(number)).to eq(subscriber)
    end
  end
end
