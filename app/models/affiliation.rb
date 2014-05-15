class Affiliation < ActiveRecord::Base
  has_paper_trail

  include Archivable
  include Audited

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  validates :affiliate_id, uniqueness: { scope: [:principal_id], message: "The relationship already exists" }, presence: true
  validates :principal_id, presence: true

  scope :ordered_by_affiliate_name, -> { includes(:affiliate).order("companies.name") }
  scope :ordered_by_principal_name, -> { includes(:principal).order("companies.name") }

  def audit_descriptor
    "affiliation between #{principal.name} and #{affiliate.name}(affiliate)"
  end

  def audit_meta
    {
        item_descriptor: "affiliation between #{principal.name} and #{affiliate.name}(affiliate)",
        item_root_class: self.affiliate.class,
        item_root_object_id: self.affiliate.id
    }
  end
end
