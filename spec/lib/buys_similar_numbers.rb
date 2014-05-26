require 'buys_similar_numbers'

require 'buys_numbers'
require 'extracts_area_codes'

describe BuysSimilarNumbers do
  let(:number) { :number }
  let(:sms_url) { :url }

  it 'feeds extracted area code to BuysNumbers' do
    ExtractsAreaCodes.should_receive(:new).with(number).and_return(double(:extrator, extract_area_code: :area_code))
    BuysNumbers.should_receive(:buy_number).with(:area_code, 'CA', :url).and_return(:new_number)

    BuysSimilarNumbers.new(number, sms_url).buy_similar_number.should eq(:new_number)
  end
end
