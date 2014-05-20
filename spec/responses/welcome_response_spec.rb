require_relative '../../app/responses/simple_response'
require_relative '../../app/responses/welcome_response'

require 'command_context'

module I18n; end
class SendsTxts; end

describe WelcomeResponse do
  include_context 'command context'

  it 'delivers a welcome response' do
    response = WelcomeResponse.new(command_context)

    relay.should_receive(:subscription_count).and_return(5)
    I18n.should_receive(:t).with('other', count: 4, locale: sender.locale).and_return('4 others')

    I18n.should_receive(:t).with('txts.welcome', relay_name: relay.name, subscriber_name: sender.name_or_anon, subscriber_count: '4 others', locale: sender.locale).and_return('welcome')
    SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome', originating_txt_id: command_context.originating_txt_id)

    response.deliver(sender)
  end
end
