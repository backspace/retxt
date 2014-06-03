require_relative '../../lib/changes_languages'

class ParsesLanguages; end

describe ChangesLanguages do
  let(:subscriber) { double }
  let(:language) { 'language' }

  let(:language_changer) { ChangesLanguages.new(subscriber, language) }

  let(:language_parser) { double }

  context 'when the language is recognised' do
    before do
      expect(ParsesLanguages).to receive(:new).with(language).and_return language_parser
      expect(language_parser).to receive(:parse).and_return :language
    end

    it 'sets the subscriber language' do
      expect(subscriber).to receive(:update_language).with(:language)

      expect(language_changer.change_language).to be true
    end
  end

  context 'when the language is not recognised' do
    before do
      expect(ParsesLanguages).to receive(:new).with(language).and_return language_parser
      expect(language_parser).to receive(:parse).and_return false
    end

    it 'returns false' do
      expect(language_changer.change_language).to be false
    end
  end
end
