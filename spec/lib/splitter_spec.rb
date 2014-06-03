require 'splitter'

describe Splitter do
  def result
    Splitter.new(message).split
  end

  context 'with a short string' do
    let(:message) { "something short" }

    it 'returns a list containing only the short string' do
      expect(result).to eq([message])
    end
  end

  context 'with a message over 160 characters' do
    let(:line) { "123456789\n" }
    let(:message) { line*18 }

    it 'returns a list containing the message split at a newline' do
      expect(result).to eq([(line*16).chop, (line*2).chop])
    end
  end
end
