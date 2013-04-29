require 'buys_numbers'

describe BuysNumbers do
  let(:client) { double('client') }
  let(:account) { double('account') }
  let(:available_phone_numbers) { double('available') }
  let(:country) { double('country') }
  let(:local) { double('local') }

  let(:incoming_phone_numbers) { double('incoming') }

  let(:chosen_phone_number) { stub(phone_number: '5551313') }
  let(:other_phone_number) { stub(phone_number: '5551212') }

  before do
    client.stub(:account).and_return(account)
    account.stub(:available_phone_numbers).and_return(available_phone_numbers)
    available_phone_numbers.stub(:get).and_return(country)
    country.stub(:local).and_return(local)
    local.stub(:list).and_return([chosen_phone_number, other_phone_number])

    account.stub(:incoming_phone_numbers).and_return(incoming_phone_numbers)
    incoming_phone_numbers.stub(:create)
  end

  it 'should trigger API calls to find a number' do
    available_phone_numbers.should_receive(:get).with('CA')
    local.should_receive(:list).with(area_code: '514')

    BuysNumbers.buy_number('514', client)
  end

  it 'should buy a number' do
    incoming_phone_numbers.should_receive(:create).with(phone_number: chosen_phone_number.phone_number)

    BuysNumbers.buy_number('514', client)
  end

  it 'should return the first phone number' do
    BuysNumbers.buy_number('514', client).should eq(chosen_phone_number.phone_number)
  end
end
