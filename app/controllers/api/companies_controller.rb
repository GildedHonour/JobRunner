class Api::CompaniesController < ApiController
  def index
    company_type = CompanyType.all_company_types[params[:company_type_code]] if params[:company_type_code]
    companies = company_type.present? ? Company.where(company_type_id: company_type) : Company.all
    respond_with companies
  end
end