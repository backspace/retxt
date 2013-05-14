require_relative '../../app/commands/modify_relay'

describe ModifyRelay do

  let(:relay) { double('relay', number: '1234').as_null_object }
  let(:i18n) { double('i18n', t: 'response') }
  let(:sends_txts) { double('sends_txts').as_null_object }

  let(:success_message) { 'success!' }
  let(:modifier) { :modify! }

  def execute
    ModifyRelay.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, modifier: modifier, success_message: success_message).execute
  end

  context 'from an admin' do
    let(:sender) { double('sender', admin: true, number: '5551313') }

    it 'modifies the relay' do
      relay.should_receive(modifier)
      execute
    end

    it 'replies with the success message' do
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: success_message)
      execute
    end
  end

  context 'from a non-admin' do
    let(:sender) { double('sender', admin: false, number: '5551313') }

    it 'does not modify the relay' do
      relay.should_not_receive(modifier)
      execute
    end

    it 'replies with the non-admin message' do
      i18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
