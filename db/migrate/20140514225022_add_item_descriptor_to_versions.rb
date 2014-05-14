class AddItemDescriptorToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :item_descriptor, :text
  end
end
