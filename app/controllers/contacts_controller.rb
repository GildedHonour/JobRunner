class ContactsController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    respond_with @contact
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

  def update
    @contact = Contact.find(params[:id])
    @contact.update_attributes(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { respond_with @contact }
      else
        format.html { render :action => :edit }
      end
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :prefix, :address, :address2, :city, :state, :zip, :email, :phone, :birthday, :job_title, :holiday_card, :do_not_email, :do_not_mail, :gift, :mmi_ballgame, :wall_calendar, :company_id, notes_attributes: [:note])
  end
end