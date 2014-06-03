require_relative '../../app/commands/language'
require 'command_context'

class ChangesLanguages; end

describe Language do
  include_context 'command context'
  let(:arguments) { 'langname' }

  def execute
    Language.new(command_context).execute
  end

  context 'when the sender is subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return true
    end

    let(:language_changer) { double }

    before do
      expect(ChangesLanguages).to receive(:new).with(sender, arguments).and_return(language_changer)
    end

    context 'when the language not is successfully changed' do
      before do
        expect(language_changer).to receive(:change_language).and_return(true)
      end

      it 'sends a confirmation' do
        expect_response_to_sender 'LanguageResponse'
        execute
      end
    end

    context 'when the language is successfully changed' do
      before do
        expect(language_changer).to receive(:change_language).and_return(false)
      end

      it 'sends a language bounce response and notifies admins' do
        expect_response_to_sender 'LanguageBounceResponse'
        expect_notification_of_admins 'LanguageBounceNotification'
        execute
      end
    end
  end

  context 'when the sender is not subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return false
    end

    it 'sends a not-subscribed command bounce and notifies admins' do
      expect_response_to_sender 'NotSubscribedCommandBounceResponse'
      expect_notification_of_admins 'NotSubscribedCommandBounceNotification'
      execute
    end
  end

  context 'when there are no arguments' do
    let(:arguments) { nil }

    before do
      # why must this be here?
      allow(relay).to receive(:subscribed?).with(sender).and_return false
    end

    it 'sends the language list response' do
      expect_response_to_sender 'LanguageListResponse'
      execute
    end
  end
end
