class InternalCompanyRelationship < ActiveRecord::Base
  has_paper_trail

  extend Enumerize
  include Archivable
  include Audited

  belongs_to :internal_company, class_name: "Company"
  belongs_to :company

  validates :role, presence: true, uniqueness: { scope: [:internal_company_id, :company_id] }

  enumerize :role, in: %i(client consultant media prospect supplier other_/_admin), default: :client

  scope :ordered_by_status_and_internal_company_name, -> { includes(:internal_company).references(:internal_company).order("internal_company_relationships.archived, companies.name") }

  def audit_meta
    {
        item_descriptor: "relationship between #{self.internal_company.name} and #{self.company.name}(#{self.role.text})",
        item_root_class: self.company.class,
        item_root_object_id: self.company.id
    }
  end
end
