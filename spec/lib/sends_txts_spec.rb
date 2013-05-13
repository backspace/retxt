require 'sends_txts'

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
end
