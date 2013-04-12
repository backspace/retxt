class RelaySettings
  include Mongoid::AppSettings

  setting :frozen, default: false
end
