class Affiliation < ActiveRecord::Base
  extend Enumerize

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  enumerize :role, in: %i(prospect client supplier list_broker list_manager list_owner), default: :client
  enumerize :status, in: %i(active inactive), default: :active

  validates :affiliate_id, uniqueness: { scope: [:role, :principal_id] }, presence: true
  validates :principal_id, presence: true
  validates :role, presence: true
end