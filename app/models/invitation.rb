class Invitation
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  belongs_to :relay
  field :number, type: String
end
