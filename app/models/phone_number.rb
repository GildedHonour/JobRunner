class PhoneNumber < ActiveRecord::Base
  extend Enumerize
  belongs_to :phonable, polymorphic: true, touch: true

  enumerize :kind, in: %i(business mobile fax home other_phone other_fax), default: :business

  validates :phone_number, presence: true

  def to_s
    str = self.phone_number
    str = "#{str} #{self.extension}" if self.extension.present?
    str = "#{kind.humanize}: #{str}" if self.kind.present?

    str
  end
end