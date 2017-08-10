Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stubs(:buy_number).returns(number)
end

Then(/^the number buyer should have bought a number from area code (\d+)$/) do |area_code|
  buy_number_invocations = Mocha::Mockery.instance.invocations.select{|invocation| invocation.method_name == :buy_number}
  invocation_area_codes = buy_number_invocations.map{|invocation| invocation.arguments.first }

  expect(invocation_area_codes).to eq([area_code])
end
