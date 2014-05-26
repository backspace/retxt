class BuysSimilarNumbers
  def initialize(number, url)
    @number = number
    @url = url
  end

  def buy_similar_number
    parser = ParsesNumbers.new(existing_number)
    parser.parse
    BuysNumbers.buy_number(parser.area_code, parser.country, url)
  end

  private
  def existing_number
    @number
  end

  def url
    @url
  end
end
