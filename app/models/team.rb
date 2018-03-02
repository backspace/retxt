class Team
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :name, type: String
  field :code, type: String

  has_many :subscribers, dependent: :delete

  def addressable_name
    name.present? ? "@#{name}" : 'anon'
  end
end
