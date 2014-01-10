class AddColumnToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_logo, :string
  end
end
