require_relative '../../app/commands/thaw'

describe Thaw do

  let(:relay) { double('relay', number: '1234').as_null_object }

  let(:i18n) { double('i18n', t: 'response') }
  let(:sends_txts) { double('sends_txts').as_null_object }

  def execute
    Thaw.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts).execute
  end

  context 'from an admin' do
    let(:sender) { double('sender', admin: true, number: '5551313') }

    it 'thaws the relay' do
      relay.should_receive(:thaw!)
      execute
    end

    it 'replies with the thaw message' do
      i18n.should_receive('t').with('txts.thaw').and_return('thaw')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'thaw')
      execute
    end
  end

  context 'from a non-admin' do
     let(:sender) { double('sender', admin: false, number: '5551313') }

     it 'does not thaw the relay' do
       relay.should_not_receive(:thaw!)
       execute
     end

     it 'replies with the non-admin message' do
       i18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
       sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
       execute
     end
  end
end
