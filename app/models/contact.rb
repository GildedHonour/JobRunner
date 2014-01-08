class Contact < ActiveRecord::Base
  extend Enumerize

  validates :first_name ,presence: true
  validates :last_name, presence: true

  belongs_to  :company
  has_many  :notes, dependent: :destroy

  enumerize :status, in: %i(active inactive), default: :active

  accepts_nested_attributes_for :notes

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  class << self
    def search(term)
      return Contact.none if term.blank?
      term_like = "%#{term}%"
      Contact.includes(:company).where("first_name ILIKE ? OR last_name ILIKE ? OR companies.name ILIKE ?", term_like, term_like, term_like)
    end

    def find_affiliated_to_company(company_ids)
      Contact.includes(company: :principal_affiliations).where('affiliations.principal_id IN (?)', company_ids).references(:affiliate_affiliations)
    end
  end
end