class CreateNotesTable < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note
      t.belongs_to :contact, index: true
    end
  end
end
