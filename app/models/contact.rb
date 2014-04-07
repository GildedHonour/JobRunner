class Contact < ActiveRecord::Base
  extend Enumerize
  include Archivable

  validates :first_name ,presence: true
  validates :last_name, presence: true

  validates :company_id, presence: true

  belongs_to :company
  belongs_to :user

  has_many :addresses, -> { order "created_at ASC" }, dependent: :destroy, as: :addressable
  has_many :notes, -> { order "created_at DESC" }, dependent: :destroy, as: :notable

  has_many :emails, -> { order "created_at ASC" }, as: :emailable, dependent: :destroy
  has_many :phone_numbers, -> { order "created_at ASC" }, as: :phonable, dependent: :destroy

  enumerize :prefix, in: %i(Mr. Mrs. Ms. Miss. Prof.)

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :addresses, reject_if: lambda { |address| address[:address_line_1].blank? }, allow_destroy: true
  accepts_nested_attributes_for :emails, reject_if: lambda { |email| email[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :phone_numbers, reject_if: lambda { |phone_number| phone_number[:phone_number].blank? }, allow_destroy: true

  def full_name
    [self.prefix, self.first_name, self.middle_name, self.last_name].compact.join(" ")
  end

  class << self
    def search(term)
      return Contact.none if term.blank?
      term_like = "%#{term}%"
      includes(:company).references(:company).where("first_name ILIKE ? OR last_name ILIKE ? OR concat(first_name, last_name) ILIKE ? OR companies.name ILIKE ?", term_like, term_like, term_like.gsub(/\s/, ""), term_like)
    end

    def with_birthday_months(month_ids)
      where('extract(month from birthday) IN (?)', month_ids)
    end

    def contacts_of_companies_with_relationship_to(internal_company_ids)
      includes(company: :internal_company_relationships).where('internal_company_relationships.internal_company_id IN (?)', internal_company_ids)
    end

    def contacts_of_companies_with_company_types(company_type_ids)
      includes(:company).references(:company).where('companies.company_type_id IN (?)', company_type_ids)
    end
  end
end