class ContactsController < ApplicationController
  respond_to :html, :js

  PAGE_SIZE = 100

  def new
    @contact = Contact.new(params[:contact])
    respond_with @contact
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contact_url(@contact)
    else
      render "new"
    end

  end

  def edit
    @contact = Contact.find(params[:id])
    render "new"
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      redirect_to contact_url(@contact)
    else
      render "new"
    end
  end

  def index
    @contacts = params[:search].present? ? Contact.search(params[:search]) : Contact.all
    @contacts = @contacts.contacts_of_company_and_its_affiliates(params[:ac]) if params[:ac].present?
    @contacts = @contacts.contacts_of_companies_with_relationship_to(params[:rc]) if params[:rc].present?
    @contacts = params[:first_name_sort] == "down" ? @contacts.order("first_name DESC") : @contacts.order("first_name ASC")
    @contacts = @contacts.page(params[:page]).per(PAGE_SIZE)

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

  def edit_communications
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js { render("edit_communications") }
    end
  end

  def update_communications
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      render "success"
    else
      render  "edit_communications"
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :mmi_ballgame, :do_not_mail, :do_not_email, :send_cookies,
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end
end