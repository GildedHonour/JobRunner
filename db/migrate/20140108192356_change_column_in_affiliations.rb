class ChangeColumnInAffiliations < ActiveRecord::Migration
  def change
  	remove_column :affiliations, :status
  	add_column :affiliations, :status, :string, :default => 'active'
  end
end
