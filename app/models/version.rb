class Version < ActiveRecord::Base
  def item_description
    self.item_descriptor || "#{self.item_type.underscore.humanize.downcase} - #{self.item_id}"
  end

  def item_changes
    YAML.load(self.object_changes)
  end

  def item_page_link
    %w(Contact Company).include?(self.item_root_class) ? "/#{self.item_root_class.tableize}/#{self.item_root_object_id}" : nil
  end
end
