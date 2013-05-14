shared_context 'command context' do
  let(:relay) { double('relay', number: '1234').as_null_object }

  let(:i18n) { double('i18n', t: 'response') }
  let(:sends_txts) { double('sends_txts').as_null_object }
  let(:sender) { double('sender', admin: false, number: '5551313') }

  def sender_is_admin
    sender.stub(:admin).and_return(true)
  end
end
