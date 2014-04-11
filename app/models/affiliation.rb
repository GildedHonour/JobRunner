class Affiliation < ActiveRecord::Base
  include Archivable

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  validates :affiliate_id, uniqueness: { scope: [:principal_id], message: "The relationship already exists" }, presence: true
  validates :principal_id, presence: true

  scope :ordered_by_affiliate_name, -> { includes(:affiliate).order("companies.name") }
  scope :ordered_by_principal_name, -> { includes(:principal).order("companies.name") }
end