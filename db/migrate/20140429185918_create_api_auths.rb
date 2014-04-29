class CreateApiAuths < ActiveRecord::Migration
  def change
    create_table :api_auths do |t|
      t.string :app
      t.text :password
      t.boolean :archived, default: false, required: true

      t.timestamps
    end
  end
end
