Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stub(:buy_number).and_return(number)
end
