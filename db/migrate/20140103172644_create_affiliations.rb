class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.string :type
      t.integer :status, default: 0
      t.integer :affiliate_id
      t.integer :principal_id

      t.timestamps
    end

    add_index :affiliations, :type
    add_index :affiliations, :affiliate_id
    add_index :affiliations, :principal_id
  end
end