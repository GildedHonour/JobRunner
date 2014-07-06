class CreateApplicationAuthorizations < ActiveRecord::Migration
  def change
    create_table :application_authorizations do |t|
      t.integer :authorized_application_id
      t.integer :user_id

      t.timestamps
    end

    add_index :application_authorizations, :authorized_application_id
    add_index :application_authorizations, :user_id
  end
end
