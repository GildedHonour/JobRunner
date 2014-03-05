class CreateInternalCompanyRelationships < ActiveRecord::Migration
  def change
    create_table :internal_company_relationships do |t|
      t.string :name
      t.string :role
      t.string :status
      t.references :internal_company
      t.references :company

      t.timestamps
    end
  end
end
