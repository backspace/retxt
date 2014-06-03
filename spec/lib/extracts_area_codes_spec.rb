require 'extracts_area_codes'
require 'invalid_number_exception'

describe ExtractsAreaCodes do
  let(:extractor) { ExtractsAreaCodes.new(number) }
  subject { extractor.extract_area_code }

  context 'with a valid number' do
    let(:number) { '+12125551212' }

    it { is_expected.to eq('212') }
  end

  context 'with a number that is too short' do
    let(:number) { '12345' }

    it 'should raise an exception' do
      expect { extractor.extract_area_code }.to raise_exception(InvalidNumberException)
    end
  end

  context 'with a number missing the country code' do
    let(:number) { '123456789012' }

    it 'should raise an exception' do
      expect { extractor.extract_area_code }.to raise_exception(InvalidNumberException)
    end
  end
end
