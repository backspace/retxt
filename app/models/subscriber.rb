class Subscriber
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :number, type: String
  field :nick, type: String

  def nick_or_anon
    nick.present? ? nick : 'anon'
  end
end
