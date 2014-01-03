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
      @contacts = Contact.search(params[:search]).page(params[:page]).per(PAGE_SIZE)
    else
      @contacts = Contact.order(:first_name).page(params[:page]).per(PAGE_SIZE)
    end

    respond_with @contacts
  end

  def show
    @contact = Contact.find(params[:id])
    @company = @contact.company
    respond_with @contact
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.update_attributes(contact_params)
    respond_with @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:name, notes_attributes: [:note])
  end
end