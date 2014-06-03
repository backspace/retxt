require_relative '../../app/responses/simple_response'
require_relative '../../app/responses/subscription_notification'
require 'command_context'

module I18n; end
class SendsTxts; end

describe SubscriptionNotification do
  include_context 'command context'

  let(:admin_1) { double(:admin, number: 1, locale: 1) }
  let(:admin_2) { double(:admin, number: 2, locale: 2) }

  it 'delivers a subscription notification' do
    notification = SubscriptionNotification.new(command_context)

    [1, 2].each do |locale|
      expect(I18n).to receive(:t).with('txts.admin.subscription', name: sender.name_or_anon, number: sender.number, locale: locale).and_return(locale)
      expect(SendsTxts).to receive(:send_txt).with(to: locale, from: relay.number, body: locale, originating_txt_id: command_context.originating_txt_id)
    end

    notification.deliver([admin_1, admin_2])
  end
end
