class AddColumnToAffiliations < ActiveRecord::Migration
  def change
    add_column :affiliations, :role, :string
  end
end
