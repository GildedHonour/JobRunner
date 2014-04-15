class InternalCompanyRelationship < ActiveRecord::Base
  has_paper_trail

  extend Enumerize
  include Archivable

  belongs_to :internal_company, class_name: "Company"
  belongs_to :company

  validates :role, presence: true, uniqueness: { scope: [:internal_company_id, :company_id] }

  enumerize :role, in: %i(client media prospect supplier other_/_admin), default: :client

  scope :ordered_by_status_and_internal_company_name, -> { includes(:internal_company).references(:internal_company).order("internal_company_relationships.archived, companies.name") }
end