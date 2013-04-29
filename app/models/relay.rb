class Relay
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :name, type: String

  has_many :subscriptions

  def subscribed?(subscriber)
    subscriptions.map(&:subscriber).include? subscriber
  end

  def self.master
    Relay.asc(:created_at).first
  end
end
