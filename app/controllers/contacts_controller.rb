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
      render :new
    end
  end

  def edit
    render :new
  end

  def update
    if @contact.update_attributes(contact_params)
      redirect_to save_success_url
    else
      render :new
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

    save_ids

    respond_with @contacts
  end

  def show
    @contacts_ids = restore_ids
    respond_with do |format|
      format.html { respond_with @contact }
      format.vcf do 
        send_data(@contact.to_vcf, filename: "#{@contact.full_name}.vcf", 
          "Content-Disposition" => "attachment", "Content-type" => "text/x-vcard; charset=utf-8")
      end
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
      render :success
    else
      render :edit_section
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
    active_filters = %i(a bm ct irr rc search name_sort).select{ |filter_param| params[filter_param].present? }
    if active_filters.present?
      session[:contact_filter_params] = params.slice(*active_filters)
    else
      session[:contact_filter_params] = nil
    end
  end

  def save_success_url
    @company ? company_url(@company) : contact_url(@contact)
  end

  def save_ids
    session[:contacts_ids] = @contacts.map(&:id)
  end

  def restore_ids
    if request.referer && URI(request.referer).path

      # URI(request.referer).path may be 
      # "/contacts/" instead of "/contacts"
      # in that case we have to remove the last slash

      referer_path = 
        if URI(request.referer).path[-1] == "/"
          URI(request.referer).path[0...URI(request.referer).path.size - 1]
        else
          URI(request.referer).path
        end

      if referer_path == contacts_path || referer_show_action?(referer_path)
        session[:contacts_ids] || @contacts.map(&:id)
      else
        @contacts.map(&:id)
      end
    else
      @contacts.map(&:id)
    end
  end

  def referer_show_action?(referer_path)
    rec_ref_url = Rails.application.routes.recognize_path(referer_path)
    rec_ref_url[:controller] == "contacts" && rec_ref_url[:action] == "show"
  end
end