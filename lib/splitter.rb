class Splitter
  def initialize(text)
    @text = text
  end

  def split
    maximum_length_per_split_text = 160

    split_text = @text.split("\n").reduce([""]) do |result, item|
      result.push("") if result.last.length + item.length > maximum_length_per_split_text
      result[-1] += "#{item}\n"

      result
    end

    split_text.map(&:strip)
  end
end
