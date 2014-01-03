class AddColumnsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :holiday_card, :boolean
    add_column :contacts, :do_not_email, :boolean
    add_column :contacts, :do_not_mail, :boolean
    add_column :contacts, :gift, :string
    add_column :contacts, :mmi_ballgame, :boolean
    add_column :contacts, :wall_calendar, :boolean
  end
end
