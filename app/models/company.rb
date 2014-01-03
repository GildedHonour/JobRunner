class Company < ActiveRecord::Base
  # All affiliations
  has_many :affiliate_affiliations, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :affiliates, through: :affiliate_affiliations, source: :affiliate, class_name: 'Company'

  has_many :principal_affiliations, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :principals, through: :principal_affiliations, source: :principal, class_name: 'Company'

  # Client affiliations
  has_many :client_affiliate_affiliations, -> { where type: ClientAffiliation.to_s }, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :client_affiliates, through: :client_affiliate_affiliations, class_name: 'Company', source: :affiliate

  has_many :client_principal_affiliations, -> { where type: ClientAffiliation.to_s }, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :client_principals, through: :client_principal_affiliations, class_name: 'Company', source: :principal

  # Prospect affiliations
  has_many :prospect_affiliate_affiliations, -> { where type: ProspectAffiliation.to_s }, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :prospect_affiliates, through: :prospect_affiliate_affiliations, class_name: 'Company', source: :affiliate

  has_many :prospect_principal_affiliations, -> { where type: ProspectAffiliation.to_s }, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :prospect_principals, through: :prospect_principal_affiliations, class_name: 'Company', source: :principal

  has_many :contacts

  # Validations
  validates :name, presence: true
end