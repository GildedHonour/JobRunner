class Note < ActiveRecord::Base
  has_paper_trail
  include Audited

	belongs_to :notable, polymorphic: true
  belongs_to :user

  def audit_meta
    {
        item_descriptor: "note '#{self.note}' for #{self.notable.audit_meta[:item_descriptor]}",
        item_root_class: self.notable.class,
        item_root_object_id: self.notable.id
    }
  end
end
