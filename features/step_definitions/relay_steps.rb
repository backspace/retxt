Given(/^outgoing txts are monitored$/) do
  @monitor_outgoing = true
  SendsTxts.stubs(:send_txt)
end

Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stubs(:buy_number).returns(number)
end
