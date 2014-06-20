class Api::CompaniesController < ApiController
  def index
    if params[:company_type_code].present?
      company_type = CompanyType.all_company_types[params[:company_type_code]]
      companies = company_type.present? ? Company.where(company_type_id: company_type) : Company.none
    else
      companies = Company.all
    end
    respond_with companies
  end
end
