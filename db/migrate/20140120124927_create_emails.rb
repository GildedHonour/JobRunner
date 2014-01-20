class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :emailable, polymorphic: true, index: true
      t.string :value

      t.timestamps
    end
  end
end
