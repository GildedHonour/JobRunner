class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :company, index: true
      t.references :user, index: true
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :birthday
      t.string :prefix
      t.string :job_title
      t.text :source

      t.boolean :do_not_email
      t.boolean :do_not_mail
      t.boolean :mmi_ballgame
      t.boolean :send_cookies
      t.boolean :contest_participant

      t.boolean :archived, default: false

      t.timestamps
    end
  end
end