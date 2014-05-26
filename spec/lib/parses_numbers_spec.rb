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
        GlobalPhone.should_receive(:parse).with(number).and_return(double(:number, territory: double(:territory, name: 'XX')))

        parser.parse
        parser.country.should eq('XX')
        parser.area_code.should be_nil
      end
    end

    context 'when the territory is US' do
      before do
        GlobalPhone.should_receive(:parse).with(number).and_return(double(:global_number, territory: double(:territory, name: 'US')))
      end

      context 'and Dialable places it in the US' do
        before do
          Dialable::NANP.should_receive(:parse).with(number).and_return(double(:dialable_number, country: 'US', areacode: :us_area_code))
        end

        it 'parses a number with an area code' do
          parser.parse
          parser.country.should eq('US')
          parser.area_code.should eq(:us_area_code)
        end
      end

      context 'and Dialable places it in Canada' do
        before do
          Dialable::NANP.should_receive(:parse).with(number).and_return(double(:dialable_number, country: 'CANADA', areacode: :canada_area_code))
        end

        it 'parses a number with an area code' do
          parser.parse
          parser.country.should eq('CA')
          parser.area_code.should eq(:canada_area_code)
        end
      end

      context 'and Dialable places it outside US/CA' do
        before do
          Dialable::NANP.should_receive(:parse).with(number).and_return(double(:dialable_number, country: 'XX'))
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
      parser.country.should eq("CA")
      parser.area_code.should eq("514")
    end

    it 'parses a number from the US' do
      parser = parser_for("+14150000000")
      parser.country.should eq("US")
      parser.area_code.should eq("415")
    end

    it 'parses a number from Austria' do
      parser = parser_for("+43 316 45678")
      parser.country.should eq("AT")
      parser.area_code.should be_nil
    end

    it 'parses a number from China' do
      parser = parser_for("+861069445464")
      parser.country.should eq("CN")
      parser.area_code.should be_nil
    end

    it 'parses a number from France' do
      parser = parser_for("+33687712345")
      parser.country.should eq("FR")
      parser.area_code.should be_nil
    end

    it 'parses a number from Nigeria' do
      parser = parser_for("+23480312345")
      parser.country.should eq("NG")
      parser.area_code.should be_nil
    end

    it 'parses a number from the United Kingdom' do
      parser = parser_for("+447700954321")
      parser.country.should eq("GB")
      parser.area_code.should be_nil
    end

    it 'parses a number from Venezuela' do
      parser = parser_for("+582954167216")
      parser.country.should eq("VE")
      parser.area_code.should be_nil
    end

    it 'throws an error for a number from Montserrat' do
      expect { parser_for("+16644911000") }.to raise_exception(UnsupportedNumberException)
    end
  end
end
