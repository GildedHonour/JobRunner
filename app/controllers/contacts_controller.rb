class ContactsController < ApplicationController
  respond_to :html

  def create
    @contact = Contact.new(contact_params)
    @contact.save
    respond_with @contact
  end

  def index
    @contacts = Contact.all
    respond_with @contacts
  end

  def show
    @contact = Contact.find(params[:id])
    respond_with @contact
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.update_attributes(contact_params)
    respond_with @contact
  end

  private
  def contact_params
    params.require(:contact).permit(:name)
  end
end