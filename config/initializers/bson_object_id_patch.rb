# Taken from https://github.com/mongoid/mongoid/pull/2947#issuecomment-22144755

module BSON
  class ObjectId
    def as_json(*args)
      to_s()
    end

    def to_json(*args)
      MultiJson.encode(as_json())
    end
  end
end
