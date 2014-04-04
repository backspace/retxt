class ExtractsAreaCodes
  def initialize(number)
    @number = number
  end

  def extract_area_code
    raise InvalidNumberException unless @number.length == 12
    raise InvalidNumberException unless @number.start_with? '+1'
    @number[2..4]
  end
end
