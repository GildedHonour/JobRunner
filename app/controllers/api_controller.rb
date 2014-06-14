class ApiController < ActionController::Base
  before_filter :authenticate!
  respond_to :json

  private

  def authenticate!
    api_auth = nil
    authenticated = authenticate_with_http_basic do |app, password|
      api_auth = ApiAuth.where(app: app).first
      api_auth && BCrypt::Password.new(api_auth.password).is_password?(password)
    end
    puts "[API Access]: #{api_auth.app}" if authenticated

    render(json: { reason: "unauthorized" }, status: 401) unless authenticated
  end
end
