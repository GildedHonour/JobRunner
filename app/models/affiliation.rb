class Affiliation < ActiveRecord::Base
  extend Enumerize
  include Archivable

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  enumerize :role, in: %i(agency account), default: :account

  validates :affiliate_id, uniqueness: { scope: [:role, :principal_id], message: "The relationship already exists" }, presence: true
  validates :principal_id, presence: true
  validates :role, presence: true

  scope :ordered_by_affiliate_name, -> { includes(:affiliate).order("companies.name") }
end