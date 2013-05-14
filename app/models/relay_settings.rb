class RelaySettings
  include Mongoid::AppSettings

  setting :display_number, default: true
end
