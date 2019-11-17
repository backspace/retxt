class BuysSimilarNumbers
  def initialize(number, url, overridden_area_code = nil)
    @number = number
    @url = url
    @overridden_area_code = overridden_area_code
  end

  def buy_similar_number
    parser = ParsesNumbers.new(existing_number)
    parser.parse
    BuysNumbers.buy_number(@overridden_area_code || parser.area_code, parser.country, url)
  end

  private
  def existing_number
    @number
  end

  def url
    @url
  end
end
