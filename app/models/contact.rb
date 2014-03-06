class Contact < ActiveRecord::Base
  extend Enumerize

  validates :first_name ,presence: true
  validates :last_name, presence: true

  belongs_to :company
  belongs_to :user

  has_many :addresses, -> { order "created_at ASC" }, dependent: :destroy, as: :addressable
  has_many :notes, -> { order "created_at ASC" }, dependent: :destroy

  has_many :emails, -> { order "created_at ASC" }, as: :emailable, dependent: :destroy
  has_many :phone_numbers, -> { order "created_at ASC" }, as: :phonable, dependent: :destroy

  enumerize :status, in: %i(active inactive), default: :active
  enumerize :prefix, in: %i(Mr. Mrs. Ms. Miss. Prof.)

  accepts_nested_attributes_for :notes
  accepts_nested_attributes_for :addresses, reject_if: lambda { |address| address[:address_line_1].blank? }, allow_destroy: true
  accepts_nested_attributes_for :emails, reject_if: lambda { |email| email[:value].blank? }, allow_destroy: true
  accepts_nested_attributes_for :phone_numbers, reject_if: lambda { |phone_number| phone_number[:value].blank? }, allow_destroy: true

  def default_email_address
    self.email_addresses.first.try(:value)
  end

  def default_phone_number
    self.phone_numbers.first.try(:value)
  end

  def full_name
    [self.prefix, self.first_name, self.middle_name, self.last_name].compact.join(" ")
  end

  class << self
    def search(term)
      return Contact.none if term.blank?
      term_like = "%#{term}%"
      Contact.includes(:company).where("first_name ILIKE ? OR last_name ILIKE ? OR companies.name ILIKE ?", term_like, term_like, term_like)
    end

    def contacts_of_company_and_its_affiliates(company_ids)
      Contact.includes(company: :principal_affiliations).
          references(:affiliate_affiliations).
          where('affiliations.principal_id IN (?) OR company_id IN (?)', company_ids, company_ids)
    end

    def contacts_of_companies_with_relationship_to(internal_company_ids)
      Contact.includes(:company).where('company_id IN (?)', internal_company_ids)
    end
  end
end