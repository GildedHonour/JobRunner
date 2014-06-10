class CompaniesController < ApplicationController
  include SearchFiltersSaver
  include AddressParamsParser

  respond_to :html, :js, :csv
  
  ENTITY_PREFIX = "company"
  FILTER_ITEMS = [:a, :ac, :ct, :irr, :rc, :search, :name_sort]
  
  def index
    @entities, @entities_all_pages = apply_filters(@entities)
    respond_with(@entities)
  end

  def new
    @entity = Company.new(params[:company])
    respond_with(@entity)
  end

  def create
    @entity = Company.new(permitted_params)
    if @entity.save
      redirect_to company_url(@entity)
    else
      render(:new)
    end
  end

  def edit
    render(:new)
  end

  def update
    if @entity.update_attributes(permitted_params_with_country_parsed)
      redirect_to(company_url(@entity))
    else
      render(:new)
    end
  end

  def show
    @entities, @entities_all_pages = apply_filters(@entities)
    @entities_ids = @entities.map(&:id)
    set_saved_filters_new_page!
    respond_with(@entity)
  end

  def destroy
    @entity.destroy
    redirect_to companies_url_with_saved_filters
  end

  def edit_section
    @section = params[:section]
    respond_to do |format|
      format.js { render(:edit_section) }
    end
  end

  def update_section
    @section = params[:section]
    if @entity.update_attributes(permitted_params)
      render(:success)
    else
      render(:edit_section)
    end
  end

  def delete_company_logo
    @entity.remove_company_logo!
    @entity.save
    redirect_to edit_company_url(@entity)
  end

  private

  def permitted_params
    params.require(:company).permit(:name, :website, :phone, :company_logo, :company_type_id,
                                    affiliate_affiliations_attributes: [:id, :archived, :affiliate_id, :role, :_destroy],
                                    principal_affiliations_attributes: [:id, :archived, :principal_id, :role, :_destroy],
                                    internal_company_relationships_attributes: [:id, :archived, :internal_company_id, :role, :_destroy],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def load_entities
    @entities = Company.all
    @entity = Company.includes(:internal_companies, :affiliates).find(params[:id]) if params[:id].present?
  end

  def apply_filters_concrete(source)
    source_filtered = get_saved_filters.has_key?(:search) ? source.search(get_saved_filters[:search]) : source
    source_filtered = source_filtered.with_affiliations_and_relationships_with_archived_status(get_saved_filters[:a]) if get_saved_filters.has_key?(:a)
    source_filtered = source_filtered.affiliated_to_company(get_saved_filters[:ac]) if get_saved_filters.has_key?(:ac)
    source_filtered = source_filtered.with_company_types(get_saved_filters[:ct]) if get_saved_filters.has_key?(:ct)
    source_filtered = source_filtered.with_internal_relationship_role(get_saved_filters[:irr]) if get_saved_filters.has_key?(:irr)
    
    source_filtered = source_filtered.relationship_with_company(get_saved_filters[:rc]) if get_saved_filters.has_key?(:rc)
    source_filtered = get_saved_filters[:name_sort] == "down" ? source_filtered.order("companies.name DESC") : source_filtered.order("companies.name ASC")
  end
end
