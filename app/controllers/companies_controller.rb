class CompaniesController < ApplicationController
  respond_to :html, :js, :csv

  PAGE_SIZE = 100

  before_filter :load_company
  before_filter :save_filters, only: :index

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
  end

  def edit
    render "new"
  end

  def update
    if @company.update_attributes(company_params)
      redirect_to company_url(@company)
    else
      render "new"
    end
  end

  def index
    @companies = params[:search].present? ? Company.search(params[:search]) : Company.all

    @companies = @companies.with_affiliations_and_relationships_with_archived_status(params[:a])  if params[:a].present?
    @companies = @companies.affiliated_to_company(params[:ac])                                    if params[:ac].present?
    @companies = @companies.with_company_types(params[:ct])                                       if params[:ct].present?
    @companies = @companies.with_internal_relationship_role(params[:irr])                         if params[:irr].present?
    @companies = @companies.relationship_with_company(params[:rc])                                if params[:rc].present?

    @companies = params[:name_sort] == "down" ? @companies.order("companies.name DESC") : @companies.order("companies.name ASC")
    @companies = @companies.page(params[:page]).per(PAGE_SIZE) unless request.format == :csv

    respond_with @companies
  end

  def show
    respond_with @company
  end

  def destroy
    @company.destroy
    redirect_to companies_url_with_saved_filters
  end

  def edit_section
    @section = params[:section]
    respond_to do |format|
      format.js { render("edit_section") }
    end
  end

  def update_section
    @section = params[:section]
    if @company.update_attributes(company_params)
      render "success"
    else
      render "edit_section"
    end
  end

  def delete_company_logo
    @company.remove_company_logo!
    @company.save
    redirect_to edit_company_url(@company)
  end

  private
  def company_params
    params.require(:company).permit(:name, :website, :phone, :company_logo, :company_type_id,
                                    affiliate_affiliations_attributes: [:id, :archived, :affiliate_id, :role, :_destroy],
                                    principal_affiliations_attributes: [:id, :archived, :principal_id, :role, :_destroy],
                                    internal_company_relationships_attributes: [:id, :archived, :internal_company_id, :role, :_destroy],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def load_company
    @company = Company.includes(:internal_companies, :affiliates).find(params[:id]) if params[:id].present?
  end

  def save_filters
    active_filters = %i(a ac ct irr rc search name_sort).select{ |filter_param| params[filter_param].present? }
    if active_filters.present?
      session[:company_filter_params] = params.slice(*active_filters)
    else
      session[:company_filter_params] = nil
    end
  end
end
