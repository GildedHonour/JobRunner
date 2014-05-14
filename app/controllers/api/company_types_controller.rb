class Api::CompanyTypesController < ApiController
  def index
    respond_with CompanyType.all
  end
end