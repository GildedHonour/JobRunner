class RemoveCommunicationColsFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :send_cookies
    remove_column :contacts, :send_mmi_ballgame_emails
  end
end
