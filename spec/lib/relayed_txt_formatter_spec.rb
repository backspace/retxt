require 'relayed_txt_formatter'

describe RelayedTxtFormatter do
  let(:sender) { double('sender', addressable_name: '@sender') }
  let(:txt) { 'hello there' }

  it 'formats the relayed txt' do
    RelayedTxtFormatter.new(sender: sender, txt: txt).format.should == "@sender sez: #{txt}"
  end
end
