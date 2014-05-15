class PhoneNumber < ActiveRecord::Base
  has_paper_trail

  extend Enumerize
  include Audited
  belongs_to :phonable, polymorphic: true, touch: true

  enumerize :kind, in: %i(business mobile fax home other_phone other_fax), default: :business

  validates :phone_number, presence: true

  def to_s
    str = self.phone_number
    str = "#{str} x#{self.extension}" if self.extension.present?
    str = "#{kind.humanize}: #{str}" if self.kind.present?

    str
  end

  def audit_meta
    {
        item_descriptor: "phone number #{self.to_s} for #{self.phonable.audit_meta[:item_descriptor]}",
        item_root_class: self.phonable.class,
        item_root_object_id: self.phonable.id
    }
  end
end
