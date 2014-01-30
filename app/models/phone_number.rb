class PhoneNumber < ActiveRecord::Base
  extend Enumerize
  belongs_to :phonable, polymorphic: true, touch: true

  enumerize :kind, in: %i(business mobile fax home other_phone other_fax), default: :business

  validates :value, presence: true

  def to_s
    self.value
  end
end