require 'buys_similar_numbers'

require 'parses_numbers'
require 'buys_numbers'

describe BuysSimilarNumbers do
  let(:number) { :number }
  let(:sms_url) { :url }

  it 'feeds extracted area code to BuysNumbers' do
    expect(ParsesNumbers).to receive(:new).with(number).and_return(parser = double(:parser))
    expect(parser).to receive(:parse)
    expect(parser).to receive(:area_code).and_return(:area_code)
    expect(parser).to receive(:country).and_return(:country)

    expect(BuysNumbers).to receive(:buy_number).with(:area_code, :country, :url).and_return(:new_number)

    expect(BuysSimilarNumbers.new(number, sms_url).buy_similar_number).to eq(:new_number)
  end

  it 'feeds the country with an overridden area code to BuysNumbers' do
    expect(ParsesNumbers).to receive(:new).with(number).and_return(parser = double(:parser))
    expect(parser).to receive(:parse)
    expect(parser).to receive(:country).and_return(:country)

    expect(BuysNumbers).to receive(:buy_number).with(:overridden_area_code, :country, :url).and_return(:new_number_with_overridden_area_code)

    expect(BuysSimilarNumbers.new(number, sms_url, :overridden_area_code).buy_similar_number).to eq(:new_number_with_overridden_area_code)
  end
end
