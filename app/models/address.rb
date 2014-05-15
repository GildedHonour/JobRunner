class Address < ActiveRecord::Base
  has_paper_trail

  extend Enumerize
  include Audited

  belongs_to :addressable, polymorphic: true, touch: true

  enumerize :country, in: %i(usa canada), default: :usa

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def audit_meta
    summary = [self.address_line_1, self.address_line_2, self.city, self.state, self.zip].compact.join(",")
    {
        item_descriptor: "address '#{summary}' for #{self.addressable.audit_meta[:item_descriptor]}",
        item_root_class: self.addressable.class,
        item_root_object_id: self.addressable.id
    }
  end
end
