class Meeting
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :code, type: String
  field :offset, type: Integer
  field :messaged, type: Boolean, default: false
  field :region, type: String
  field :answer, type: String
  field :description_masks, type: Array

  has_and_belongs_to_many :teams, inverse_of: nil

  belongs_to :chosen, class_name: "Subscriber"

  def full_code
    "#{code}#{teams.map(&:code).join}"
  end
end
