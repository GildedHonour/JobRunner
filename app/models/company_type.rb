class CompanyType < ActiveRecord::Base
  validates :name, :code, presence: true, uniqueness: true
  scope :ordered_by_name, -> { order("company_types.name") }

  def can_be_affiliation_affiliate?
    CompanyType.affiliate_company_types.include?(self)
  end

  def can_be_affiliation_principal?
    CompanyType.principal_company_types.include?(self)
  end

  def to_s
    self.name
  end

  class << self
    def affiliate_company_types
      all_company_types.values_at("nonprofit", "commercial_mailer")
    end

    def list_manager_company_type
      all_company_types["list_manager"]
    end

    def principal_company_types
      all_company_types.values_at("agency")
    end

    def internal
      all_company_types["internal"]
    end

    def all_company_types
      return @all_company_types if @all_company_types
      @all_company_types = {}
      CompanyType.all.each { |company_type| @all_company_types[company_type.code] = company_type }
      @all_company_types
    end
  end
end
