class Version < ActiveRecord::Base
  def item_description
    self.item_descriptor || "#{self.item_type.underscore.humanize.downcase} - #{self.item_id}"
  end

  def item_changes
    YAML.load(self.object_changes)
  end
end
