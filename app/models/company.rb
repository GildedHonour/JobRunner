class Company < ActiveRecord::Base
  include Archivable

  has_many :addresses, -> { order "created_at" }, dependent: :destroy, as: :addressable

  has_many :affiliate_affiliations, foreign_key: 'principal_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :affiliates, -> { order "name" }, through: :affiliate_affiliations, source: :affiliate, class_name: 'Company'

  has_many :principal_affiliations, foreign_key: 'affiliate_id', dependent: :destroy, class_name: 'Affiliation'
  has_many :principals, through: :principal_affiliations, source: :principal, class_name: 'Company'

  has_many :internal_company_relationships, dependent: :destroy
  has_many :internal_companies, through: :internal_company_relationships, source: :internal_company, class_name: 'Company'

  has_many :contacts, -> { order "first_name" },  dependent: :destroy
  has_many :phone_numbers, -> { order "created_at ASC" }, as: :phonable, dependent: :destroy

  belongs_to :company_type

  accepts_nested_attributes_for :addresses, reject_if: lambda { |address| address[:address_line_1].blank? }, allow_destroy: true
  accepts_nested_attributes_for :phone_numbers, reject_if: lambda { |phone_number| phone_number[:phone_number].blank? }, allow_destroy: true
  accepts_nested_attributes_for :affiliate_affiliations, reject_if: lambda { |affiliation| affiliation[:affiliate_id].blank? }, allow_destroy: true
  accepts_nested_attributes_for :principal_affiliations, reject_if: lambda { |affiliation| affiliation[:principal_id].blank? }, allow_destroy: true
  accepts_nested_attributes_for :internal_company_relationships, reject_if: lambda { |relationship| relationship[:internal_company_id].blank? }, allow_destroy: true

  mount_uploader :company_logo, CompanyLogoUploader

  validates :name, presence: true, uniqueness: true

  scope :ordered_by_affiliate_name, -> { includes(affiliate_affiliations: :affiliate).order("companies.name") }
  scope :ordered_by_name, -> { order("companies.name") }
  scope :internal, -> { where(company_type_id: CompanyType.internal.id ) }

  def all_principal_and_affiliates
    (self.affiliates + self.principals).sort_by(&:name)
  end

  class << self
    def with_affiliation_affiliate_company_types
      Company.where("company_type_id IN (?)", CompanyType.affiliate_company_types)
    end

    def with_affiliation_principal_company_types
      Company.where("company_type_id IN (?)", CompanyType.principal_company_types)
    end

    def search(term)
      return Company.none if term.blank?
      term_like = "%#{term}%"
      where("companies.name ILIKE ?", term_like)
    end

    def affiliated_to_company(company_ids)
      includes(:principal_affiliations).references(:principal_affiliations).where('affiliations.principal_id IN (?)', company_ids).references(:affiliate_affiliations)
    end

    def with_company_types(company_type_ids)
      where(company_type_id: company_type_ids)
    end

    def with_internal_relationship_role(roles)
      includes(:internal_company_relationships).references(:internal_company_relationships).where('internal_company_relationships.role IN (?)', roles)
    end

    def relationship_with_company(company_ids)
      includes(:internal_company_relationships).references(:internal_company_relationships).where('internal_company_relationships.internal_company_id IN (?)', company_ids)
    end

    def with_affiliations_and_relationships_with_archived_status(archived_status)
      archived_status = [archived_status].flatten.map{ |status| status.to_s == "true" }
      includes([:principal_affiliations, :internal_company_relationships]).
        references([:principal_affiliations, :internal_company_relationships]).
        where("affiliations.archived IN (?) OR internal_company_relationships.archived IN (?)", archived_status, archived_status)
    end
  end
end