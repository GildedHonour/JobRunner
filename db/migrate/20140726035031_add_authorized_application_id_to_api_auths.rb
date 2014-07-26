class AddAuthorizedApplicationIdToApiAuths < ActiveRecord::Migration
  def change
    add_column :api_auths, :authorized_application_id, :integer
    remove_column :api_auths, :app
  end
end
