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
      @companies = Company.search(params[:search]).page(params[:page]).per(PAGE_SIZE)
    else
      @companies = Company.order(:name).page(params[:page]).per(PAGE_SIZE)
    end
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
