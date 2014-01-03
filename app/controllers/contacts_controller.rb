class ContactsController < ApplicationController
  respond_to :html, :js

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    respond_with @contact
  end

  def index
    @contacts = params[:search].present? ? Contact.search(params[:search]) : Contact.all.order(:first_name)
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