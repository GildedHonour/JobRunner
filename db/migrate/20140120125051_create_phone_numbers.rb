class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.references :phonable, polymorphic: true, index: true
      t.string :value
      t.string :kind

      t.timestamps
    end
  end
end
