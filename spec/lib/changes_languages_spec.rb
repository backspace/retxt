require_relative '../../lib/changes_languages'

class ParsesLanguages; end

describe ChangesLanguages do
  let(:subscriber) { double }
  let(:language) { 'language' }

  let(:language_changer) { ChangesLanguages.new(subscriber, language) }

  let(:language_parser) { double }

  context 'when the language is recognised' do
    before do
      ParsesLanguages.should_receive(:new).with(language).and_return language_parser
      language_parser.should_receive(:parse).and_return :language
    end

    it 'sets the subscriber language' do
      subscriber.should_receive(:update_language).with(:language)

      language_changer.change_language.should be_true
    end
  end

  context 'when the language is not recognised' do
    before do
      ParsesLanguages.should_receive(:new).with(language).and_return language_parser
      language_parser.should_receive(:parse).and_return false
    end

    it 'returns false' do
      language_changer.change_language.should be_false
    end
  end
end
