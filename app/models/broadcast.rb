class Broadcast
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :offset, type: Integer
  field :messaged, type: Boolean, default: false
  field :content, type: String
end
