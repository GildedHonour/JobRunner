class CompaniesController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @company = Company.new(params[:company])
    respond_with @company
  end

  def create
    @company = Company.new(company_params)
    @success_message = "Company saved." if @company.save

    respond_to do |format|
      format.js { render("new") }
    end
  end

  def edit
    @company = Company.find(params[:id])
    respond_to do |format|
      format.js { render("new") }
    end
  end

  def update
    @company = Company.find(params[:id])
    @company.update_attributes(company_params)
    @success_message = "Company updated." if @company.save

    respond_to do |format|
      format.js { render("new") }
    end
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

  private
  def company_params
    params.require(:company).permit(:name, :website, :phone,
                                    affiliate_affiliations_attributes: [:id, :affiliate_id, :role, :_destroy],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :_destroy],
                                    phone_numbers_attributes: [:id, :kind, :value, :_destroy]
    )
  end
end
