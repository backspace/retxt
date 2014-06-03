require 'buys_numbers'

describe BuysNumbers do
  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:available_phone_numbers) { double('available') }
  let(:client_country) { double('country') }
  let(:local) { double('local') }

  let(:country) { 'XX' }

  let(:incoming_phone_numbers) { double('incoming') }

  let(:chosen_phone_number) { double(phone_number: '5551313') }
  let(:other_phone_number) { double(phone_number: '5551212') }

  before do
    allow(client).to receive(:account).and_return(account)
    allow(account).to receive(:available_phone_numbers).and_return(available_phone_numbers)
    allow(available_phone_numbers).to receive(:get).and_return(client_country)
    allow(client_country).to receive(:local).and_return(local)
    allow(local).to receive(:list).and_return([chosen_phone_number, other_phone_number])

    allow(account).to receive(:incoming_phone_numbers).and_return(incoming_phone_numbers)
    allow(incoming_phone_numbers).to receive(:create)
  end

  it 'should trigger API calls to find a number' do
    expect(available_phone_numbers).to receive(:get).with(country)
    expect(local).to receive(:list).with(area_code: '514')

    BuysNumbers.buy_number('514', country, nil, client)
  end

  it 'should buy a number and configure it' do
    sms_url = double('url')
    expect(incoming_phone_numbers).to receive(:create).with(phone_number: chosen_phone_number.phone_number, sms_url: sms_url)

    BuysNumbers.buy_number('514', country, sms_url, client)
  end

  it 'should return the first phone number' do
    expect(BuysNumbers.buy_number('514', country, nil, client)).to eq(chosen_phone_number.phone_number)
  end
end
