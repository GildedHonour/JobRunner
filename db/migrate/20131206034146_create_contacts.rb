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

      t.boolean :do_not_email
      t.boolean :do_not_mail
      t.string :gift
      t.boolean :mmi_ballgame

      t.string :status

      t.timestamps
    end
  end
end