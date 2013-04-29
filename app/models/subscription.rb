class Subscription
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  belongs_to :relay
  belongs_to :subscriber
end
