class Meeting
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  has_and_belongs_to_many :subscribers, inverse_of: nil

  def code
    subscribers.map(&:code).join
  end
end
