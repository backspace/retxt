class ChangesNames
  def self.change_name(subscriber, new_name)
    if subscriber.present? && new_name.present?
      subscriber.update_attribute(:name, new_name)
    end
  end
end
