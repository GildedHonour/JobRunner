class Company < ActiveRecord::Base
  # All affiliations
  has_many :affiliate_affiliations, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :affiliates, through: :affiliate_affiliations, source: :affiliate, class_name: 'Company'

  has_many :principal_affiliations, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :principals, through: :principal_affiliations, source: :principal, class_name: 'Company'

  # Client affiliations
  has_many :client_affiliate_affiliations, -> { where role: 'client' }, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :client_affiliates, through: :client_affiliate_affiliations, class_name: 'Company', source: :affiliate

  has_many :client_principal_affiliations, -> { where role: 'client' }, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :client_principals, through: :client_principal_affiliations, class_name: 'Company', source: :principal

  # Prospect affiliations
  has_many :prospect_affiliate_affiliations, -> { where role: 'prospect' }, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :prospect_affiliates, through: :prospect_affiliate_affiliations, class_name: 'Company', source: :affiliate

  has_many :prospect_principal_affiliations, -> { where role: 'prospect' }, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :prospect_principals, through: :prospect_principal_affiliations, class_name: 'Company', source: :principal

  has_many :contacts

  mount_uploader :company_logo, CompanyLogoUploader

  # Validations
  validates :name, presence: true

  class << self
    def search(term)
      return Company.none if term.blank?
      term_like = "%#{term}%"
      Company.where("name ILIKE ?", term_like)
    end

    def find_affiliated_to_company(company_ids)
      Company.includes(:principal_affiliations).where('affiliations.principal_id IN (?)', company_ids).references(:affiliate_affiliations)
    end

    def all_principals
      Company.order("name").find(*Affiliation.pluck(:principal_id).uniq)
    end
  end
end