class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :company, index: true
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :address2
      t.string :city
      t.string :state
      t.integer :zip
      t.string :email
      t.string :phone
      t.date :birthday
      t.string :prefix
      t.string :job_title

      t.boolean :holiday_card
      t.boolean :do_not_email
      t.boolean :do_not_mail
      t.string :gift
      t.boolean :mmi_ballgame
      t.boolean :wall_calendar

      t.string :status

      t.timestamps
    end
  end
end