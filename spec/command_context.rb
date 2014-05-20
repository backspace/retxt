shared_context 'command context' do

  # TODO: is this a factory?! frozen and/or as_null_object trouble

  let(:relay) { double('relay', number: '1234', frozen: false, moderated: false).as_null_object }

  let(:sender) { double('sender', admin: false, name_or_anon: 'sender', number: '5551313', addressable_name: '@sender', absolute_name: '@sender#5551313', anonymous?: false, locale: :locale) }
  let(:txt) { double('txt', id: 'abc') }

  let(:command_context) { double('command_context', sender: sender, relay: relay, arguments: defined?(arguments) ? arguments : '', txt: txt, originating_txt_id: txt.id, application_url: 'url', locale: :locale) }

  def sender_is_admin
    sender.stub(:admin).and_return(true)
  end

  def expect_response_to_sender(klass)
    expect_response_to(sender, klass)
  end

  def expect_response_to(target, klass)
    response_class = double(klass)
    stub_const(klass, response_class)
    response_class.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(target)})
  end

  def expect_notification_of_admins(klass)
    expect_notification_of(relay.admins, klass)
  end

  def expect_notification_of(target, klass)
    response_class = double(klass)
    stub_const(klass, response_class)
    response_class.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(target)})
  end
end
