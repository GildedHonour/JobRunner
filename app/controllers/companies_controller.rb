class CompaniesController < ApplicationController
  respond_to :html, :js

  def create
    @company = Company.new(company_params)
    @company.save
    respond_with @company
  end

  def index
    @companies = params[:search].present? ? Company.search(params[:search]) : Company.all.order(:name)
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
