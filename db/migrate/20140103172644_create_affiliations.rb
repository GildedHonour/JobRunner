class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.string :role
      t.boolean :archived, default: false
      t.references :affiliate, index: true
      t.references :principal, index: true

      t.timestamps
    end
  end
end