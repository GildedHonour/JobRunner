class CreateAuthorizedApplications < ActiveRecord::Migration
  def change
    create_table :authorized_applications do |t|
      t.string :name
      t.timestamps
    end
  end
end
