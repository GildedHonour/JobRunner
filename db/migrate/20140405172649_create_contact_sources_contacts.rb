class CreateContactSourcesContacts < ActiveRecord::Migration
  def change
    create_table :contact_sources_contacts do |t|
      t.references :contact
      t.references :contact_source
    end
  end
end
