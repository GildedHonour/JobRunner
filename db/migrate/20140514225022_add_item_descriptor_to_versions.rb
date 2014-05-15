class AddItemDescriptorToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :item_descriptor, :text
    add_column :versions, :item_root_class, :string
    add_column :versions, :item_root_object_id, :string
  end
end
