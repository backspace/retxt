require 'timestamp_formatter'

describe TimestampFormatter do
  let(:relay) { double(:relay, timestamp: timestamp) }
  let(:txt) { double(:txt, created_at: created_at) }
  let(:created_at) { double(:created_at) }

  context 'on a relay with a timestamp' do
    let(:timestamp) { double(:string, "present?" => true) }

    it 'calls the time formatter and appends a space' do
      expect(created_at).to receive(:strftime).with(timestamp).and_return '  result'
      expect(TimestampFormatter.new(relay: relay, txt: txt).format).to eq('result ')
    end
  end

  context 'on a relay with a non-present timestamp' do
    let(:timestamp) { double(:blank, "present?" => false) }

    it 'calls the time formatter and returns blank' do
      expect(TimestampFormatter.new(relay: relay, txt: txt).format).to eq('')
    end
  end
end
