class CompaniesController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def create
    @company = Company.new(company_params)
    @company.save
    respond_with @company
  end

  def index
    if params[:search].present?
      @companies = Company.search(params[:search])
    else
      @companies = Company.order(:name)
    end
    @companies = Company.find_affiliated_to_company(params[:selected_companies].split(',')).order(:name) if params[:selected_companies].present?

    @companies = @companies.page(params[:page]).per(PAGE_SIZE)

    @all_principals = Company.all_principals.group_by(&:internal)

    respond_with @companies
  end

  def show
    @company = Company.find(params[:id])
    respond_with @company
  end

  def update
    @company = Company.find(params[:id])
    @company.update_attributes(company_params)
    respond_with @company
  end

  private
  def company_params
    params.require(:company).permit(:name)
  end
end
