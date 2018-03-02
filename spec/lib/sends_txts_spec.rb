require 'sends_txts'

class Splitter; end;

describe SendsTxts do
  let(:from) { "1234" }
  let(:to) { "5678" }
  let(:body) { "A txt!" }
  let(:oid) { 'abc' }

  let(:client) { double('client') }
  let(:messages) { double('messages') }

  before do
    allow(client).to receive(:messages).and_return(messages)

    stub_const('Txt', double)
  end

  it "sends a txt" do
    expect(messages).to receive(:create).with(from: from, to: to, body: body)
    expect(Txt).to receive(:create).with(from: from, to: to, body: body, originating_txt_id: oid)

    SendsTxts.send_txt(client: client, from: from, to: to, body: body, originating_txt_id: oid)
  end
end
