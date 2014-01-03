class Contact < ActiveRecord::Base
  validates :first_name ,presence: true
  validates :last_name, presence: true

  belongs_to  :company

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  class << self
    def search(term)
      return Contact.none if term.blank?

      term_like = "%#{term}%"
      Contact.includes(:company).where("first_name ILIKE ? OR last_name ILIKE ? OR companies.name ILIKE ?", term_like, term_like, term_like)
    end
  end
end