class Subscriber
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :nick, type: String

  field :admin, type: Boolean
  attr_protected :admin

  def nick_or_anon
    nick.present? ? nick : 'anon'
  end

  scope :admins, where(admin: true)
end
