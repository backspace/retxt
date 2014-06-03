require 'sends_txts'

class Splitter; end;

describe SendsTxts do
  let(:from) { "1234" }
  let(:to) { "5678" }
  let(:body) { "A txt!" }
  let(:oid) { 'abc' }

  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:sms) { double('sms') }
  let(:messages) { double('messages') }

  before do
    allow(client).to receive(:account).and_return(account)
    allow(account).to receive(:sms).and_return(sms)
    allow(sms).to receive(:messages).and_return(messages)

    stub_const('Txt', double)
  end

  it "sends a txt" do
    expect(messages).to receive(:create).with(from: from, to: to, body: body)
    expect(Txt).to receive(:create).with(from: from, to: to, body: body, originating_txt_id: oid)

    SendsTxts.send_txt(client: client, from: from, to: to, body: body, originating_txt_id: oid)
  end

  it "truncates long txts" do
    long_message = "0"*161
    truncated_message = double('truncated')
    expect(long_message).to receive(:truncate).with(160).and_return(truncated_message)
    expect(messages).to receive(:create).with(from: from, to: to, body: truncated_message)
    expect(Txt).to receive(:create).with(from: from, to: to, body: truncated_message, originating_txt_id: oid)

    SendsTxts.send_txt(client: client, from: from, to: to, body: long_message, originating_txt_id: oid)
  end

  context 'sending possibly-longer txts' do
    let(:splitter) { double('splitter') }

    before do
      allow(Splitter).to receive(:new).and_return(splitter)
    end

    it "sends txts" do
      expect(SendsTxts).to receive(:send_txt).with(from: from, to: to, body: body, originating_txt_id: oid)
      allow(splitter).to receive(:split).and_return([body])
      SendsTxts.send_txts(from: from, to: to, body: body, originating_txt_id: oid)
    end

    it "breaks up a long txt into many and sends them" do
      first_txt, second_txt = double('first_txt'), double('second_txt')
      allow(splitter).to receive(:split).and_return([first_txt, second_txt])

      expect(SendsTxts).to receive(:send_txt).with(from: from, to: to, body: first_txt, originating_txt_id: oid)
      expect(SendsTxts).to receive(:send_txt).with(from: from, to: to, body: second_txt, originating_txt_id: oid)

      SendsTxts.send_txts(from: from, to: to, body: body, originating_txt_id: oid)
    end
  end
end
