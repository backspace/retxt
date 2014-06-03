require 'parses_numbers'

require 'global_phone'
GlobalPhone.db_path = 'db/global_phone.json'

require 'dialable'

require 'unsupported_number_exception'

describe ParsesNumbers do
  context 'with mocking' do
    let(:number) { :number }

    let(:parser) { ParsesNumbers.new(number) }

    context 'when the territory is not US' do
      it 'parses the number' do
        expect(GlobalPhone).to receive(:parse).with(number).and_return(double(:number, territory: double(:territory, name: 'XX')))

        parser.parse
        expect(parser.country).to eq('XX')
        expect(parser.area_code).to be_nil
      end
    end

    context 'when the territory is US' do
      before do
        expect(GlobalPhone).to receive(:parse).with(number).and_return(double(:global_number, territory: double(:territory, name: 'US')))
      end

      context 'and Dialable places it in the US' do
        before do
          expect(Dialable::NANP).to receive(:parse).with(number).and_return(double(:dialable_number, country: 'US', areacode: :us_area_code))
        end

        it 'parses a number with an area code' do
          parser.parse
          expect(parser.country).to eq('US')
          expect(parser.area_code).to eq(:us_area_code)
        end
      end

      context 'and Dialable places it in Canada' do
        before do
          expect(Dialable::NANP).to receive(:parse).with(number).and_return(double(:dialable_number, country: 'CANADA', areacode: :canada_area_code))
        end

        it 'parses a number with an area code' do
          parser.parse
          expect(parser.country).to eq('CA')
          expect(parser.area_code).to eq(:canada_area_code)
        end
      end

      context 'and Dialable places it outside US/CA' do
        before do
          expect(Dialable::NANP).to receive(:parse).with(number).and_return(double(:dialable_number, country: 'XX'))
        end

        it 'raises an exception' do
          expect {parser.parse}.to raise_exception(UnsupportedNumberException)
        end
      end
    end
  end

  context 'with examples' do
    def parser_for(number)
      parser = ParsesNumbers.new(number)
      parser.parse
      parser
    end

    it 'parses a number from Canada' do
      parser = parser_for("+15145551313")
      expect(parser.country).to eq("CA")
      expect(parser.area_code).to eq("514")
    end

    it 'parses a number from the US' do
      parser = parser_for("+14150000000")
      expect(parser.country).to eq("US")
      expect(parser.area_code).to eq("415")
    end

    it 'parses a number from Austria' do
      parser = parser_for("+43 316 45678")
      expect(parser.country).to eq("AT")
      expect(parser.area_code).to be_nil
    end

    it 'parses a number from China' do
      parser = parser_for("+861069445464")
      expect(parser.country).to eq("CN")
      expect(parser.area_code).to be_nil
    end

    it 'parses a number from France' do
      parser = parser_for("+33687712345")
      expect(parser.country).to eq("FR")
      expect(parser.area_code).to be_nil
    end

    it 'parses a number from Nigeria' do
      parser = parser_for("+23480312345")
      expect(parser.country).to eq("NG")
      expect(parser.area_code).to be_nil
    end

    it 'parses a number from the United Kingdom' do
      parser = parser_for("+447700954321")
      expect(parser.country).to eq("GB")
      expect(parser.area_code).to be_nil
    end

    it 'parses a number from Venezuela' do
      parser = parser_for("+582954167216")
      expect(parser.country).to eq("VE")
      expect(parser.area_code).to be_nil
    end

    it 'throws an error for a number from Montserrat' do
      expect { parser_for("+16644911000") }.to raise_exception(UnsupportedNumberException)
    end
  end
end
