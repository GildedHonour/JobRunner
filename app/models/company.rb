class Company < ActiveRecord::Base

  has_many :addresses, -> { order "created_at" }, dependent: :destroy, as: :addressable

  # All affiliations
  has_many :affiliate_affiliations, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :affiliates, -> { order "name" }, through: :affiliate_affiliations, source: :affiliate, class_name: 'Company'

  has_many :principal_affiliations, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :principals, through: :principal_affiliations, source: :principal, class_name: 'Company'

  has_many :contacts, -> { order "created_at" },  dependent: :destroy
  has_many :phone_numbers, -> { order "created_at ASC" }, as: :phonable, dependent: :destroy

  accepts_nested_attributes_for :addresses, reject_if: lambda { |address| address[:address_line_1].blank? }, allow_destroy: true
  accepts_nested_attributes_for :phone_numbers, reject_if: lambda { |phone_number| phone_number[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :affiliate_affiliations, reject_if: lambda { |affiliation| affiliation[:affiliate_id].blank? }, allow_destroy: true

  mount_uploader :company_logo, CompanyLogoUploader

  # Validations
  validates :name, presence: true, uniqueness: true

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

  def affiliate_affiliations_of_affiliate(company)
    self.affiliate_affiliations.where(affiliate_id: company).order("created_at")
  end
end