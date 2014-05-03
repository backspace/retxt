class Txt
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from, type: String
  field :to, type: String
  field :body, type: String
  field :service_id, type: String
  field :originating_txt_id, type: String
end
