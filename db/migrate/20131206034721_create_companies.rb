class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :address2
      t.string :city
      t.string :company_logo
      t.string :state
      t.integer :zip
      t.string :website
      t.string :phone
      t.string :company_type
      t.boolean :internal

      t.timestamps
    end
  end
end