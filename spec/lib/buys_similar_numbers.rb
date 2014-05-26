require 'buys_similar_numbers'

require 'parses_numbers'
require 'buys_numbers'

describe BuysSimilarNumbers do
  let(:number) { :number }
  let(:sms_url) { :url }

  it 'feeds extracted area code to BuysNumbers' do
    ParsesNumbers.should_receive(:new).with(number).and_return(parser = double(:parser))
    parser.should_receive(:parse)
    parser.should_receive(:area_code).and_return(:area_code)
    parser.should_receive(:country).and_return(:country)

    BuysNumbers.should_receive(:buy_number).with(:area_code, :country, :url).and_return(:new_number)

    BuysSimilarNumbers.new(number, sms_url).buy_similar_number.should eq(:new_number)
  end
end
