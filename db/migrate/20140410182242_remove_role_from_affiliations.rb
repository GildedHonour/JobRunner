class RemoveRoleFromAffiliations < ActiveRecord::Migration
  def change
    remove_column :affiliations, :role
  end
end
