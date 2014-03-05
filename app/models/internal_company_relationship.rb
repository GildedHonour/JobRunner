class InternalCompanyRelationship < ActiveRecord::Base
  extend Enumerize

  belongs_to :internal_company, class_name: "Company"
  belongs_to :company

  validates :role, presence: true, uniqueness: { scope: [:internal_company_id, :company_id] }

  enumerize :role, in: %i(client prospect supplier list_broker list_manager list_owner), default: :client
  enumerize :status, in: %i(active inactive), default: :active

  scope :ordered_by_internal_company_name, -> { includes(:company).order("companies.name") }
end