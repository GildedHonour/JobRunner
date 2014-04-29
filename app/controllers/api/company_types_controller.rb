class Api::CompanyTypesController < ApiController
  def index
    respond_with CompanyType.all.as_json(only: :name, methods: [:code])
  end
end