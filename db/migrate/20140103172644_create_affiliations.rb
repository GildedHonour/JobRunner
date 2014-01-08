class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.string :role
      t.string :status
      t.integer :affiliate_id
      t.integer :principal_id

      t.timestamps
    end

    add_index :affiliations, :role
    add_index :affiliations, :affiliate_id
    add_index :affiliations, :principal_id
  end
end