class ContactsController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @contact = Contact.new(params[:contact])
    respond_with @contact
  end

  def create
    @contact = Contact.new(contact_params)
    @success_message = "Contact saved." if @contact.save

    respond_to do |format|
      format.js { render("new") }
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
    @contact.update_attributes(contact_params)
    @success_message = "Contact updated." if @contact.save

    respond_to do |format|
      format.js { render("new") }
    end
  end

  def index
    if params[:search].present?
      @contacts = Contact.search(params[:search])
    else
      @contacts = Contact.order(:first_name)
    end
    @contacts = Contact.find_affiliated_to_company(params[:selected_companies].split(',')).order(:first_name) if params[:selected_companies].present?

    @contacts = @contacts.page(params[:page]).per(PAGE_SIZE)

    @all_principals = Company.all_principals.group_by(&:internal)

    respond_with @contacts
  end

  def show
    @contact = Contact.find(params[:id])
    respond_with @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :wall_calendar, :mmi_ballgame, :holiday_card, :do_not_email,
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :kind, :value, :_destroy]
    )
  end
end