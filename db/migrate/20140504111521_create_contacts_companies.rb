class CreateContactsCompanies < ActiveRecord::Migration
  def change
    create_table :contacts_companies do |t|
      t.string :contact_id
      t.string :company_id
      t.string :is_active
      t.timestamps
    end
  end
end
