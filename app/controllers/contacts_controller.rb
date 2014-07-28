class ContactsController < ApplicationController
  include SearchFiltersSaver
  include AddressParamsParser

  respond_to :html, :js, :csv, :vcf, :json
  before_filter :authenticate_admin!, only: [:new_invite, :invite, :re_invite]

  ENTITY_PREFIX = "contact"
  FILTER_ITEMS = [:a, :bm, :ct, :irr, :rc, :search, :name_sort, :dm_em]

  def index
    @entities, @entities_all_pages = apply_filters(@entities)
    respond_with(@entities)
  end
  
  def new
    @entity = @entities.build
    respond_with(@entity)
  end

  def create
    @entity = @entities.build(permitted_params)
    if @entity.save
      redirect_to(save_success_url)
    else
      render(:new)
    end
  end

  def edit
    render(:new)
  end

  def update
    if @entity.update_attributes(permitted_params_with_country_parsed)
      redirect_to(save_success_url)
    else
      render(:new)
    end
  end

  def show
    @entities, @entities_all_pages = apply_filters(@entities)
    set_saved_filters_new_page!
    respond_with do |format|
      format.html { respond_with(@entity) }
      format.vcf do 
        send_data(@entity.to_vcf, filename: "#{@entity.full_name}.vcf", "Content-Disposition" => "attachment",
                  "Content-type" => "text/x-vcard; charset=utf-8"
        )
      end
    end
  end

  def destroy
    @entity.destroy
    redirect_to(destroy_success_url)
  end

  def edit_section
    respond_to do |format|
      format.js { render(:edit_section) }
    end
  end

  def update_section
    if @entity.update_attributes(permitted_params)
      render(:success)
    else
      render(:edit_section)
    end
  end

  def new_invite
    @entity = Contact.find(params[:id])
    @user = @entity.build_user
    respond_with(@user)
  end

  def invite
    @entity = Contact.find(params[:id])
    @user = User.invite!({ email: params[:user][:email] }, current_user) { |user| user.contacts << @entity } 
    partial = @user.errors.present? ? :new_invite : :success_invite
    respond_to do |format|
      format.js { render(partial) }
    end
  end

  def re_invite
    @entity = Contact.find(params[:id])
    @user = User.invite!({ email: @entity.user.email }, current_user)
    flash[:success] = "The user has been re-invited successfully."
    redirect_to(contact_url(@entity))
  rescue
    flash[:danger] = "Something went wrong, try again."
    render(:show)
  end

  def get_addresses
    comp = Company.find(params[:company_id])
    respond_to do |format|
      format.json do 
        render(json: { addresses: comp.addresses })
      end
    end
  end

   def get_phone_numbers
    comp = Company.find(params[:company_id])
    respond_to do |format|
      format.json do
        items = comp.phone_numbers.map do |phn| 
          { id: phn.id, kind: phn.kind, phone_number: phn.phone_number, extension: phn.extension, str: phn.to_s }
        end

        render(json: { phone_numbers: items })
      end
    end
  end

  private

  def permitted_params
    params.require(:contact).permit(:first_name, :middle_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :contest_participant, :send_mmi_ballgame_emails, :do_not_mail, :do_not_email, :send_cookies, contact_source_ids: [],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def destroy_success_url
    @company ? company_url(@company) : contacts_url_with_saved_filters
  end

  def load_entities
    @company = Company.find(params[:company_id]) if params[:company_id].present?
    @entities = @company ? @company.contacts : Contact.includes(:company, :emails, :phone_numbers, :addresses)
    @entity = @entities.find(params[:id]) if params[:id].present?
  end

  def save_success_url
    @company ? company_url(@company) : contact_url(@entity)
  end

  def apply_filters_concrete(source)
    source_filtered = get_saved_filters.has_key?(:search) ? source.search(get_saved_filters[:search]) : source
    source_filtered = source_filtered.with_archived_status(get_saved_filters[:a]) if get_saved_filters.has_key?(:a)
    source_filtered = source_filtered.with_birthday_months(get_saved_filters[:bm]) if get_saved_filters.has_key?(:bm)
    source_filtered = source_filtered.contacts_of_companies_with_company_types(get_saved_filters[:ct]) if get_saved_filters.has_key?(:ct)
    source_filtered = source_filtered.contacts_of_companies_with_internal_relationship_role(get_saved_filters[:irr]) if get_saved_filters.has_key?(:irr)

    source_filtered = source_filtered.contacts_of_companies_with_relationship_to(get_saved_filters[:rc]) if get_saved_filters.has_key?(:rc)
    source_filtered = get_saved_filters[:name_sort] == "down" ? source_filtered.order("first_name DESC") : source_filtered.order("first_name ASC")
  
    if get_saved_filters.has_key?(:dm_em)
      source_filtered = source_filtered.do_mail if get_saved_filters[:dm_em].include?("mail")
      source_filtered = source_filtered.do_email if get_saved_filters[:dm_em].include?("email")
    end

    source_filtered
  end
end
