class RelaySettings
  include Mongoid::AppSettings

  setting :frozen, default: false
  setting :display_number, default: true
end
