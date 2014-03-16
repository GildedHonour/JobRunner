class PhoneNumber < ActiveRecord::Base
  extend Enumerize
  belongs_to :phonable, polymorphic: true, touch: true

  enumerize :kind, in: %i(business mobile fax home other_phone other_fax), default: :business

  validates :phone_number, presence: true

  def to_s
    if(self.extension.present?)
      "#{self.phone_number} #{self.extension}"
    else
      "#{self.phone_number}"
    end
  end
end