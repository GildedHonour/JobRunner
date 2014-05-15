class Email < ActiveRecord::Base
  has_paper_trail
  include Audited

  belongs_to :emailable, polymorphic: true, touch: true
  validates :value, presence: true

  def to_s
    self.value
  end

  def audit_descriptor
    "email #{self.to_s} for #{self.emailable.audit_descriptor}"
  end
end
