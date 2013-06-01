class ChangesNames
  def self.change_name(subscriber, new_name)
    if subscriber.present? && new_name.present? && subscriber.name != new_name
      subscriber.update_attribute(:name, get_unique_name(new_name))
    end
  end

  private
  def self.get_unique_name(name)
    while Subscriber.where(name: name).present?
      name = name.sub(/(\d)*$/) { |s| s.to_i + 1}
    end

    name
  end
end
