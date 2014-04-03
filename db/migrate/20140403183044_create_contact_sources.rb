class CreateContactSources < ActiveRecord::Migration
  def change
    create_table :contact_sources do |t|
      t.string :name
    end
  end
end
