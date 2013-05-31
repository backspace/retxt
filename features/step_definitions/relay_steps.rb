Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stubs(:buy_number).returns(number)
end
