class Affiliation < ActiveRecord::Base
  extend Enumerize

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  enumerize :role, in: %i(customer client prospect supplier list_broker list_manager list_owner media other_/_admin website_signup website_/_contest_signup), default: :client
  enumerize :status, in: %i(active inactive), default: :active

  validates :affiliate_id, uniqueness: { scope: [:role, :principal_id], message: "The relationship already exists" }, presence: true
  validates :principal_id, presence: true
  validates :role, presence: true

  scope :ordered_by_affiliate_name, -> { includes(:affiliate).order("companies.name") }
end