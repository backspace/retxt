class Subscriber
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :name, type: String

  field :admin, type: Boolean
  attr_protected :admin

  has_many :subscriptions

  def name_or_anon
    name.present? ? name : 'anon'
  end

  def addressable_name
    name.present? ? "@#{name}" : 'anon'
  end

  def anonymous?
    !name.present?
  end

  scope :admins, where(admin: true)

  def sent
    Txt.where(from: number)
  end

  def admin!
    self.admin = true
    save
  end

  def unadmin!
    self.admin = false
    save
  end
end
