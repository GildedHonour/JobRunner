class ApiController < ActionController::Base
  before_filter :authenticate!
  respond_to :json

  private

  def authenticate!
    authenticated = authenticate_with_http_basic do |app, password|
      app = ApiAuth.where(app: app).first
      app && BCrypt::Password.new(app.password).is_password?(password)
    end

    render(json: { reason: "unauthorized" }, status: 401) unless authenticated
  end
end
