class Note < ActiveRecord::Base
  has_paper_trail
  include Audited

	belongs_to :notable, polymorphic: true
  belongs_to :user

  def audit_descriptor
    "note '#{self.note}' for #{self.notable.audit_descriptor}"
  end
end
