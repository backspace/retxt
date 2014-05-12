class Subscription
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  belongs_to :relay
  belongs_to :subscriber

  field :muted, type: Boolean, default: false
  field :voiced, type: Boolean, default: false

  def mute
    update_attribute(:muted, true)
  end

  def unmute
    update_attribute(:muted, false)
  end

  def voice
    update_attribute(:voiced, true)
  end

  def unvoice
    update_attribute(:voiced, false)
  end
end
