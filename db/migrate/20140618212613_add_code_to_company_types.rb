class AddCodeToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :code, :string

    CompanyType.all.each do |company_type|
      company_type.update_attribute(:code, company_type.name.underscore.gsub(" ", "_"))
    end
  end
end
