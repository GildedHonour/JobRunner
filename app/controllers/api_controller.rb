class ApiController < ActionController::Base
  before_filter :authenticate!
  respond_to :json

  private
  
  def authenticate!
    unless authenticate_with_http_basic { |app, password| ApiAuth.where(app: app, password: password).present? }
      render(json: { reason: "unauthorized" }, status: 401)
    end
  end
end