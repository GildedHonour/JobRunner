class AddCasColsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :force_logout, :boolean
    add_column :users, :cas_service_ticket, :string

    add_index :users, :cas_service_ticket
  end
end
