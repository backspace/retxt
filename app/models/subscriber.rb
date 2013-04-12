class Subscriber
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :name, type: String

  field :admin, type: Boolean
  attr_protected :admin

  def name_or_anon
    name.present? ? name : 'anon'
  end

  scope :admins, where(admin: true)

  def sent
    Txt.where(from: number)
  end
end
