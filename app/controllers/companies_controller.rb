class CompaniesController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @company = Company.new(params[:company])
    respond_with @company
  end

  def create
    @company = Company.new(company_params)
    success = @company.save

    respond_to do |format|
      format.js { success ? render("success") : render("new") }
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
    success = @company.update_attributes(company_params)

    respond_to do |format|
      format.js { success ? render("success") : render("new") }
    end
  end

  def index
    @companies = params[:search].present? ? Company.search(params[:search]) : Company.all
    @companies = @companies.affiliated_to_company(params[:c]) if params[:c].present?
    @companies = params[:name_sort] == "down" ? @companies.order("name DESC") : @companies.order("name ASC")
    @companies = @companies.page(params[:page]).per(PAGE_SIZE)

    @all_principals = Company.all_principals.group_by(&:internal)

    respond_with @companies
  end

  def show
    @company = Company.includes(:affiliates).find(params[:id])
    respond_with @company
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_url
  end

  def edit_affiliations
    @company = Company.includes(:affiliates).find(params[:company_id])
    respond_to do |format|
      format.js { render("edit_affiliations") }
    end
  end

  def update_affiliations
    @company = Company.includes(:affiliates).find(params[:company_id])
    @company.update_attributes(company_params)
    @success_message = "Relationships updated." if @company.save

    respond_to do |format|
      format.js { render("edit_affiliations") }
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :website, :phone, :company_logo,
                                    affiliate_affiliations_attributes: [:id, :affiliate_id, :role, :_destroy],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    phone_numbers_attributes: [:id, :kind, :value, :_destroy]
    )
  end
end
