require 'relayed_txt_formatter'
require 'timestamp_formatter'

describe RelayedTxtFormatter do
  let(:relay) { double('relay') }
  let(:sender) { double('sender', addressable_name: '@sender') }
  let(:txt) { double(:txt, body: 'hello there') }

  let(:timestring) { 'timestring' }
  let(:timestamp_formatter) { double(:timestamp_formatter, format: "#{timestring} ") }

  before do
    TimestampFormatter.should_receive(:new).with(relay: relay, txt: txt).and_return(timestamp_formatter)
  end

  it 'formats the relayed txt' do
    RelayedTxtFormatter.new(relay: relay, sender: sender, txt: txt).format.should == "#{timestring} @sender sez: #{txt.body}"
  end
end
