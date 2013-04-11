require 'spec_helper'

describe ChangesNames do
  context 'with an existing subscriber' do
    let(:subscriber) { Subscriber.create(name: 'francine') }
    let(:new_name) { 'pascal' }

    it "changes the subscriber's name" do
      ChangesNames.change_name(subscriber, new_name)
      subscriber.reload
      subscriber.name.should == new_name
    end

    context 'when a subscriber with the new name exists' do
      let!(:other_subscriber) { Subscriber.create(name: new_name) }

      it "changes the subscriber's name to an incremented copy of the name" do
        ChangesNames.change_name(subscriber, new_name)
        subscriber.reload
        subscriber.name.should == "#{new_name}1"
      end

      context 'and a subscriber with the incremented name exists' do
        let!(:yet_another_subscriber) { Subscriber.create(name: "#{new_name}1") }

        it "changes the subscriber's name to an incremented copy of the name" do
          ChangesNames.change_name(subscriber, new_name)
          subscriber.reload
          subscriber.name.should == "#{new_name}2"
        end
      end
    end
  end
end
