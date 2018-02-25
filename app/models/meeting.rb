class Meeting
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :code, type: String
  field :offset, type: Integer

  has_and_belongs_to_many :subscribers, inverse_of: nil

  def full_code
    "#{code}#{subscribers.map(&:code).join}"
  end

  # FIXME where should this live? database probs
  START = Time.zone.parse "2018-03-06 18:30"
end
