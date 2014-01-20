class ContactsController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def create
    @contact = Contact.new(contact_params)
    @contact.company = Company.first
    @contact.save
    respond_to do |format|
      format.js { render("new") }
    end
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.update_attributes(contact_params)
    @contact.company = Company.first

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
    @company = @contact.company
    @notes = Note.where(:contact_id => @contact)
    respond_with @contact
  end

  def edit
    @contact = Contact.find(params[:id])
    @company = @contact.company
    @notes = Note.where(:contact_id => @contact)
    respond_with @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :prefix,
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :_destroy]
    )
  end
end