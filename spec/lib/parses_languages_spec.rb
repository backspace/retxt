require_relative '../../lib/parses_languages'

module I18n; end

describe ParsesLanguages do
  let(:language) { 'language' }

  let(:parser) { ParsesLanguages.new(language) }
  subject { parser.parse }

  before do
    expect(I18n).to receive(:available_locales).and_return([:one, :two])
  end

  context 'when the language name matches an existing language' do
    before do
      expect(I18n).to receive(:t).with('language_name', locale: :one).and_return('onelang')
      expect(I18n).to receive(:t).with('language_name', locale: :two).and_return('Language')
    end

    it { is_expected.to eq(:two) }
  end

  context 'when the language name matches a prefix of an existing language' do
    before do
      expect(I18n).to receive(:t).with('language_name', locale: :one).and_return('onelang')
      expect(I18n).to receive(:t).with('language_name', locale: :two).and_return('languagelongname')
    end

    it { is_expected.to eq(:two) }
  end

  context 'when the language name matches a prefix of an existing language' do
    before do
      expect(I18n).to receive(:t).with('language_name', locale: :one).and_return('onelang')
      expect(I18n).to receive(:t).with('language_name', locale: :two).and_return('twolang')
    end

    it { is_expected.to be false }
  end

end
