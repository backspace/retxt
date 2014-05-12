require_relative '../../app/responses/subscription_notification'
require 'command_context'

describe SubscriptionNotification do
  include_context 'command context'

  let(:admin_1) { double(:admin, number: 1, locale: 1) }
  let(:admin_2) { double(:admin, number: 2, locale: 2) }

  it 'delivers a subscription notification' do
    notification = SubscriptionNotification.new(command_context)

    [1, 2].each do |locale|
      I18n.should_receive(:t).with('txts.admin.subscribed', name: sender.name_or_anon, number: sender.number, locale: locale).and_return(locale)
      SendsTxts.should_receive(:send_txt).with(to: locale, from: relay.number, body: locale, originating_txt_id: command_context.originating_txt_id)
    end

    notification.deliver([admin_1, admin_2])
  end
end
