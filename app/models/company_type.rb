class CompanyType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  scope :ordered_by_name, -> { order("company_types.name") }

  def self.internal
    where("name ILIKE 'internal'").first
  end

  def self.not_internal
    where.not("name ILIKE 'internal'")
  end

  def to_s
    self.name
  end
end
