require 'txts_relay_admins'
require 'sends_txts'

describe TxtsRelayAdmins do
  let(:relay) { double('relay', number: '1234') }
  let(:admin) { double('admin', number: '2345') }
  let(:admins) { [admin] }
  let(:oid) { 'abc' }

  let(:body) { 'the txt' }

  before do
    relay.stub(:admins).and_return(admins)
  end

  it 'sends a txt to every admin' do
    SendsTxts.should_receive(:send_txt).with(from: relay.number, to: admin.number, body: body, originating_txt_id: oid)
    TxtsRelayAdmins.txt_relay_admins(relay: relay, body: body, originating_txt_id: oid)
  end
end
