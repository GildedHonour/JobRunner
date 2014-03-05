class CompanyType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def self.internal
    where("name ILIKE 'internal'").first
  end

  def to_s
    self.name
  end
end
