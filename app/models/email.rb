class Email < ActiveRecord::Base
  has_paper_trail
  include Audited

  belongs_to :emailable, polymorphic: true, touch: true
  validates :value, presence: true

  def to_s
    self.value
  end

  def audit_meta
    {
        item_descriptor: "email #{self.to_s} for #{self.emailable.audit_meta[:item_descriptor]}",
        item_root_class: self.emailable.class,
        item_root_object_id: self.emailable.id
    }
  end
end
