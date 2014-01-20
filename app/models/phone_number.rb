class PhoneNumber < ActiveRecord::Base
  extend Enumerize
  belongs_to :phonable, polymorphic: true, touch: true

  enumerize :kind, in: %i(office residence), default: :office

  validates :value, presence: true
end