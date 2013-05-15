require 'sends_txts'

class Splitter; end;

describe SendsTxts do
  let(:from) { "1234" }
  let(:to) { "5678" }
  let(:body) { "A txt!" }

  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:sms) { double('sms') }
  let(:messages) { double('messages') }

  before do
    client.stub(:account).and_return(account)
    account.stub(:sms).and_return(sms)
    sms.stub(:messages).and_return(messages)
  end

  it "sends a txt" do
    messages.should_receive(:create).with(from: from, to: to, body: body)

    SendsTxts.send_txt(client: client, from: from, to: to, body: body)
  end

  context 'sending possibly-longer txts' do
    let(:splitter) { double('splitter') }

    before do
      Splitter.stub(:new).and_return(splitter)
    end

    it "sends txts" do
      SendsTxts.should_receive(:send_txt).with(from: from, to: to, body: body)
      splitter.stub(:split).and_return([body])
      SendsTxts.send_txts(from: from, to: to, body: body)
    end

    it "breaks up a long txt into many and sends them" do
      first_txt, second_txt = double('first_txt'), double('second_txt')
      splitter.stub(:split).and_return([first_txt, second_txt])

      SendsTxts.should_receive(:send_txt).with(from: from, to: to, body: first_txt)
      SendsTxts.should_receive(:send_txt).with(from: from, to: to, body: second_txt)

      SendsTxts.send_txts(from: from, to: to, body: body)
    end
  end
end
