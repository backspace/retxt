class Meeting
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :code, type: String

  has_and_belongs_to_many :subscribers, inverse_of: nil

  def full_code
    "#{code}#{subscribers.map(&:code).join}"
  end
end
