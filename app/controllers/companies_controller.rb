class CompaniesController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @company = Company.new(params[:company])
    respond_with @company
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to company_url(@company)
    else
      render "new"
    end
    respond_with @company, location: company_url(@company)
  end

  def edit
    @company = Company.find(params[:id])
    render "new"
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(company_params)
      redirect_to company_url(@company)
    else
      render "new"
    end
  end

  def index
    @companies = params[:search].present? ? Company.search(params[:search]) : Company.all
    @companies = @companies.affiliated_to_company(params[:ac]) if params[:ac].present?
    @companies = @companies.relationship_with_company(params[:rc]) if params[:rc].present?
    @companies = params[:name_sort] == "down" ? @companies.order("companies.name DESC") : @companies.order("companies.name ASC")
    @companies = @companies.page(params[:page]).per(PAGE_SIZE)

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
    @company = Company.includes(:affiliates).find(params[:id])
    respond_to do |format|
      format.js { render("edit_affiliations") }
    end
  end

  def update_affiliations
    @company = Company.includes(:affiliates).find(params[:id])
    @company.update_attributes(company_params)
    @success_message = "Affiliations updated." if @company.save

    respond_to do |format|
      format.js { render("edit_affiliations") }
    end
  end

  def edit_internal_company_relationships
    @company = Company.includes(:internal_companies).find(params[:id])
    respond_to do |format|
      format.js { render("edit_internal_company_relationships") }
    end
  end

  def update_internal_company_relationships
    @company = Company.includes(:internal_companies).find(params[:id])
    @company.update_attributes(company_params)
    @success_message = "Relationships updated." if @company.save

    respond_to do |format|
      format.js { render("edit_internal_company_relationships") }
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :website, :phone, :company_logo, :company_type_id,
                                    affiliate_affiliations_attributes: [:id, :affiliate_id, :role, :_destroy],
                                    internal_company_relationships_attributes: [:id, :internal_company_id, :role, :_destroy],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    phone_numbers_attributes: [:id, :kind, :value, :_destroy]
    )
  end
end
