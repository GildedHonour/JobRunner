class Affiliation < ActiveRecord::Base
  extend Enumerize

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  enumerize :role, in: %i(prospect client supplier list_broker list_manager list_owner unassigned), default: :unassigned
  enumerize :status, in: %i(active inactive), default: :active
end