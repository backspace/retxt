class Txt
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from, type: String
  field :to, type: String
  field :body, type: String
  field :service_id, type: String
  field :originating_txt_id, type: String

  scope :from, -> (number) { where(from: number) }

  def receiver
    Subscriber.find_by(number: to)
  end

  def sender
    Subscriber.find_by(number: from)
  end

  def results
    Txt.where(originating_txt_id: id)
  end
end
