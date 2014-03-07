class InternalCompanyRelationship < ActiveRecord::Base
  extend Enumerize
  include Archivable

  belongs_to :internal_company, class_name: "Company"
  belongs_to :company

  validates :role, presence: true, uniqueness: { scope: [:internal_company_id, :company_id] }

  enumerize :role, in: %i(client prospect supplier list_broker list_manager list_owner), default: :client

  scope :ordered_by_internal_company_name, -> { includes(:company).order("companies.name") }
end