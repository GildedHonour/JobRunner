class ContactsController < ApplicationController
  respond_to :html, :js, :csv, :vcf

  PAGE_SIZE = 100

  before_filter :load_contacts
  before_filter :save_filters, only: :index


  def new
    @contact = @contacts.build
    respond_with @contact
  end

  def create
    @contact = @contacts.build(contact_params)
    if @contact.save
      redirect_to save_success_url
    else
      render "new"
    end
  end

  def edit
    render "new"
  end

  def update
    if @contact.update_attributes(contact_params)
      redirect_to save_success_url
    else
      render "new"
    end
  end

  def index
    @contacts = params[:search].present? ? @contacts.search(params[:search]) : @contacts

    @contacts = @contacts.with_archived_status(params[:a])                                    if params[:a].present?
    @contacts = @contacts.with_birthday_months(params[:bm])                                   if params[:bm].present?
    @contacts = @contacts.contacts_of_companies_with_company_types(params[:ct])               if params[:ct].present?
    @contacts = @contacts.contacts_of_companies_with_internal_relationship_role(params[:irr]) if params[:irr].present?
    @contacts = @contacts.contacts_of_companies_with_relationship_to(params[:rc])             if params[:rc].present?

    @contacts = params[:first_name_sort] == "down" ? @contacts.order("first_name DESC") : @contacts.order("first_name ASC")
    @contacts = @contacts.page(params[:page]).per(PAGE_SIZE) unless request.format == :csv

    respond_with @contacts
  end

  def show
    respond_with do |format|
      format.html { respond_with @contact }
      format.vcf { send_data(@contact.to_vcf, filename: "#{@contact.full_name}.vcf", "Content-Disposition" => "attachment", "Content-type" => "text/x-vcard; charset=utf-8") }
    end
  end

  def destroy
    @contact.destroy
    redirect_to destroy_success_url
  end

  def edit_section
    @section = params[:section]
    respond_to do |format|
      format.js { render("edit_section") }
    end
  end

  def update_section
    @section = params[:section]
    if @contact.update_attributes(contact_params)
      render "success"
    else
      render "edit_section"
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :middle_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :contest_participant, :send_mmi_ballgame_emails, :do_not_mail, :do_not_email, :send_cookies, contact_source_ids: [],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def destroy_success_url
    @company ? company_url(@company) : contacts_url_with_saved_filters
  end

  def load_contacts
    @company = Company.find(params[:company_id]) if params[:company_id].present?
    @contacts = @company ? @company.contacts : Contact.all
    @contact = @contacts.find(params[:id]) if params[:id].present?
  end

  def save_filters
    active_filters = %i(a bm ct irr rc search first_name_sort).select{ |filter_param| params[filter_param].present? }
    if active_filters.present?
      session[:contact_filter_params] = params.slice(*active_filters)
    else
      session[:contact_filter_params] = nil
    end
  end

  def save_success_url
    @company ? company_url(@company) : contact_url(@contact)
  end
end