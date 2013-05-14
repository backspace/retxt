class Relay
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :name, type: String

  field :frozen, type: Boolean, default: false
  field :closed, type: Boolean, default: false

  has_many :subscriptions, dependent: :delete

  def subscribed?(subscriber)
    subscription_for(subscriber).present?
  end

  def subscription_for(subscriber)
    subscriptions.where(subscriber: subscriber).first
  end

  def self.master
    Relay.asc(:created_at).first
  end

  def freeze!
    update_attribute(:frozen, true)
  end

  def thaw!
    update_attribute(:frozen, false)
  end

  def close!
    update_attribute(:closed, true)
  end

  def open!
    update_attribute(:closed, false)
  end
end
