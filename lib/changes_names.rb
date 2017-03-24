class ChangesNames
  def self.change_name(subscriber, new_name)
    if subscriber.present? && new_name.present? && subscriber.name != new_name
      subscriber.update_attribute(:name, get_unique_name(new_name))
    end
  end

  private
  def self.get_unique_name(name)
    # It’s apparently impossible to query Mongo case-insensitively
    downcase_name = name.downcase
    downcase_existing_names = Subscriber.pluck(:name).compact.map(&:downcase)

    while downcase_existing_names.include? downcase_name
      name = name.sub(/(\d)*$/) { |s| s.to_i + 1}
      downcase_name = name.downcase
    end

    name
  end
end
