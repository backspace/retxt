class BuysSimilarNumbers
  def initialize(number, url)
    @number = number
    @url = url
  end

  def buy_similar_number
    new_area_code = ExtractsAreaCodes.new(@number).extract_area_code
    BuysNumbers.buy_number(new_area_code, url)
  end

  private
  def existing_number
    @number
  end

  def url
    @url
  end
end
