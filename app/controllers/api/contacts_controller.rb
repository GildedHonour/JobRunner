class Api::ContactsController < ApiController
  def index
    company = Company.find(params[:company_id])
    respond_with company.contacts
  end
end
