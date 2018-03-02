class Relay
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :name, type: String

  field :frozen, type: Boolean, default: false
  field :closed, type: Boolean, default: false
  field :moderated, type: Boolean, default: false
  field :timestamp, type: String

  field :start, type: DateTime, default: Time.zone.parse("2018-03-06 18:30")

  has_many :subscriptions, dependent: :delete

  default_scope ->{ order(created_at: :asc) }

  def subscribed?(subscriber)
    subscription_for(subscriber).present?
  end

  def subscription_for(subscriber)
    subscriptions.where(subscriber: subscriber).first
  end

  def self.master
    Relay.asc(:created_at).first
  end

  def freeze
    update_attribute(:frozen, true)
  end

  def thaw
    update_attribute(:frozen, false)
  end

  def close
    update_attribute(:closed, true)
  end

  def open
    update_attribute(:closed, false)
  end

  def moderate
    update_attribute(:moderated, true)
  end

  def unmoderate
    update_attribute(:moderated, false)
  end

  def rename(name)
    update_attribute(:name, name)
  end

  def timestamp!(timestamp = nil)
    update_attribute(:timestamp, timestamp)
  end

  def start!(start = nil)
    update_attribute(:start, start)
  end

  def subscribers
    subscriptions.map(&:subscriber)
  end

  def admins
    subscribers.select(&:admin)
  end

  def non_admins
    subscribers.reject(&:admin)
  end

  def subscription_count
    subscriptions.count
  end
end
