class Affiliation < ActiveRecord::Base
  # When we get Rails 4.1 - http://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html
  # enum status: [ :active, :archived ]

  belongs_to :affiliate, class_name: 'Company'
  belongs_to :principal, class_name: 'Company'

  ROLES = ['Prospct', 'Client', 'Supplier', 'List Broker', 'List Manager', 'List Owner']
end