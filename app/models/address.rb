class Address < ActiveRecord::Base
  has_paper_trail

  extend Enumerize

  belongs_to :addressable, polymorphic: true, touch: true

  enumerize :country, in: %i(usa canada), default: :usa

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
end