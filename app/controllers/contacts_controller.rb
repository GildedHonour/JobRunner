class ContactsController < ApplicationController
  respond_to :html, :js, :csv

  PAGE_SIZE = 100

  before_filter :load_contacts

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
    @contact = @contacts.find(params[:id])
    render "new"
  end

  def update
    @contact = @contacts.find(params[:id])
    if @contact.update_attributes(contact_params)
      redirect_to save_success_url
    else
      render "new"
    end
  end

  def index
    @contacts = params[:search].present? ? @contacts.search(params[:search]) : @contacts

    @contacts = @contacts.with_archived_status(params[:a])                        if params[:a].present?
    @contacts = @contacts.with_birthday_months(params[:bm])                       if params[:bm].present?
    @contacts = @contacts.contacts_of_companies_with_company_types(params[:ct])   if params[:ct].present?
    @contacts = @contacts.contacts_of_companies_with_relationship_to(params[:rc]) if params[:rc].present?

    @contacts = params[:first_name_sort] == "down" ? @contacts.order("first_name DESC") : @contacts.order("first_name ASC")
    @contacts = @contacts.page(params[:page]).per(PAGE_SIZE) unless request.format == :csv

    respond_with @contacts
  end

  def show
    @contact = @contacts.find(params[:id])
    respond_with @contact
  end

  def destroy
    @contact = @contacts.find(params[:id])
    @contact.destroy
    redirect_to destroy_success_url
  end

  def edit_communications
    @contact = @contacts.find(params[:id])
    respond_to do |format|
      format.js { render("edit_communications") }
    end
  end

  def update_communications
    @contact = @contacts.find(params[:id])
    if @contact.update_attributes(contact_params)
      render "success"
    else
      render  "edit_communications"
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :middle_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :contest_participant, :mmi_ballgame, :do_not_mail, :do_not_email, :send_cookies, :source,
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def load_contacts
    @company = Company.find(params[:company_id]) if params[:company_id].present?
    @contacts = @company ? @company.contacts : Contact.all
  end

  def save_success_url
    @company ? company_url(@company) : contact_url(@contact)
  end

  def destroy_success_url
    @company ? company_url(@company) : contacts_url
  end
end