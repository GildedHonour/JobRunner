class CreateInternalCompanyRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :name
      t.string :role
      t.references :internal_company
      t.references :company

      t.timestamps
    end
  end
end
