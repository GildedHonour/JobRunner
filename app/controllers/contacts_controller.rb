class ContactsController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @contact = Contact.new(params[:contact])
    respond_with @contact
  end

  def create
    @contact = Contact.new(contact_params)
    success = @contact.save

    respond_to do |format|
      format.js { success ? render("success") : render("new") }
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js { render("new") }
    end
  end

  def update
    @contact = Contact.find(params[:id])
    success = @contact.update_attributes(contact_params)

    respond_to do |format|
      format.js { success ? render("success") : render("new") }
    end
  end

  def index
    @contacts = params[:search].present? ? Contact.search(params[:search]) : Contact.all
    @contacts = @contacts.contacts_of_company_and_its_affiliates(params[:c]) if params[:c].present?
    @contacts = params[:first_name_sort] == "down" ? @contacts.order("first_name DESC") : @contacts.order("first_name ASC")
    @contacts = @contacts.page(params[:page]).per(PAGE_SIZE)

    @all_principals = Company.all_principals.group_by(&:internal)

    respond_with @contacts
  end

  def show
    @contact = Contact.find(params[:id])
    respond_with @contact
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_url
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :wall_calendar, :mmi_ballgame, :holiday_card, :do_not_mail, :do_not_email,
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :kind, :value, :_destroy]
    )
  end
end