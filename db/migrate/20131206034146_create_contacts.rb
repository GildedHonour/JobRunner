class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :company_id
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.integer :zip
      t.string :email
      t.string :phone
      t.date :birthday
      t.string :prefix
      t.string :job_title
    end

    add_index :contacts, :company_id
  end
end