shared_context 'command context' do

  # TODO: is this a factory?! frozen and/or as_null_object trouble

  let(:relay) { double('relay', number: '1234', frozen: false, moderated: false).as_null_object }

  let(:i18n) { double('i18n', t: 'response') }
  let(:sends_txts) { double('sends_txts').as_null_object }
  let(:txts_relay_admins) { double('txts_relay_admins').as_null_object }
  let(:sender) { double('sender', admin: false, name_or_anon: 'sender', number: '5551313', addressable_name: '@sender', absolute_name: '@sender#5551313', anonymous?: false) }
  let(:txt) { double('txt', id: 'abc') }

  let(:command_context) { double('command_context', sender: sender, relay: relay, arguments: defined?(arguments) ? arguments : '', txt: txt, originating_txt_id: txt.id, application_url: 'url', locale: :locale) }

  before do
    stub_const('I18n', i18n)
    stub_const('SendsTxts', sends_txts)
    stub_const('TxtsRelayAdmins', txts_relay_admins)
  end

  def sender_is_admin
    sender.stub(:admin).and_return(true)
  end
end
