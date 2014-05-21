require 'relayed_txt_formatter'
require 'timestamp_formatter'

module I18n; end

describe RelayedTxtFormatter do
  let(:relay) { double('relay') }
  let(:sender) { double('sender', addressable_name: '@sender') }
  let(:recipient) { double('recipient', locale: :locale) }
  let(:txt) { double(:txt, body: 'hello there') }

  let(:timestring) { 'timestring' }
  let(:timestamp_formatter) { double(:timestamp_formatter, format: "#{timestring} ") }

  before do
    TimestampFormatter.should_receive(:new).with(relay: relay, txt: txt).and_return(timestamp_formatter)
  end

  it 'formats the relayed txt' do
    formatted_string = double
    I18n.should_receive(:t).with('txts.relay_template', time: "#{timestring} ", sender: sender.addressable_name, body: txt.body, locale: recipient.locale).and_return formatted_string
    RelayedTxtFormatter.new(relay: relay, sender: sender, recipient: recipient, txt: txt).format.should == formatted_string
  end
end
