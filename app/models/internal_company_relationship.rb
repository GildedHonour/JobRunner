class InternalCompanyRelationship < ActiveRecord::Base
  belongs_to :internal_company, class_name: "Company"
  belongs_to :company

  validates :role, presence: true, uniqueness: { scope: [:internal_company_id, :company_id] }
end