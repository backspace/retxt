Before do
  SendsTxts.stubs(:send_txt)
end

After do
  SendsTxts.unstub(:send_txt)
end
