class Subscription
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  belongs_to :relay
  belongs_to :subscriber

  field :muted, type: Boolean, default: false

  def mute!
    update_attribute(:muted, true)
  end

  def unmute!
    update_attribute(:muted, false)
  end
end
