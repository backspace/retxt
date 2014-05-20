require_relative '../../app/responses/simple_response'
require_relative '../../app/responses/disclaimer_response'

require 'command_context'

module I18n; end
class SendsTxts; end

describe DisclaimerResponse do
  include_context 'command context'

  it 'delivers a disclaimer response' do
    response = DisclaimerResponse.new(command_context)

    I18n.should_receive(:t).with('txts.disclaimer', locale: sender.locale).and_return('disclaimer')
    SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer', originating_txt_id: command_context.originating_txt_id)

    response.deliver(sender)
  end
end
