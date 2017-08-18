Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stubs(:buy_number).returns(number)
end

class MockDeleter
  def self.delete_relay(options)
    options[:relay].destroy
  end
end

Given(/^the relay deleter deletes relays$/) do
  # stub_const("DeletesRelays", MockDeleter)
  DeletesRelays.stubs(:delete_relay)

    original_stub = DeletesRelays.method(:delete_relay)

    define_singleton_method_by_proc(DeletesRelays, :delete_relay, Proc.new do |*args|
      options = args.first
      options[:relay].destroy

      original_stub.call(*args)
    end)
  # expect(mock_deleter).to receive(:delete_relay) do |options|
  #   options[:relay].destroy
  # end
end
