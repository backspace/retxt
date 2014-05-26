class ParsesNumbers
  def initialize(number)
    @number = number
  end

  def parse
    global_number = GlobalPhone.parse(number)
    @country = global_number.territory.name

    if @country == 'US'
      dialable_number = Dialable::NANP.parse(number)
      @country = dialable_number.country

      raise UnsupportedNumberException unless @country == 'CANADA' || @country == 'US'
      @area_code = dialable_number.areacode
      @country = 'CA' if dialable_number.country == 'CANADA'
    end
  end

  def country
    @country
  end

  def area_code
    @area_code
  end

  private
  def number
    @number
  end
end
