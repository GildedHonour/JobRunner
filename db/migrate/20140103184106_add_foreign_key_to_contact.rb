class AddForeignKeyToContact < ActiveRecord::Migration
  def change
    add_reference :contacts, :company, index: true
  end
end
