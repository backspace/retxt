module TxtsHelper
  def who_messages(subscribers)
    roll_items = subscribers.map{|subscriber|
      "#{subscriber.addressable_name}#{subscriber.admin ? '*' : ''} #{subscriber.number}"
    }

    max_message_length = 160 - 1

    message_strings = roll_items.reduce([""]) { |result, item|
      result.push("") if result.last.length + item.length + 1 > max_message_length
      result[-1] += "\n#{item}"

      result
    }
  end
end
