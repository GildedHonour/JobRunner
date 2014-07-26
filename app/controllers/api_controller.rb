class ApiController < ActionController::Base
  before_filter :authenticate!
  skip_before_filter :verify_authenticity_token

  respond_to :json

  private
  def authenticate!
    authenticated = authenticate_with_http_basic do |app, password|
      authorized_application = AuthorizedApplication.where(name: app).first
      authorized = authorized_application && authorized_application.api_auths.any? { |api_auth| BCrypt::Password.new(api_auth.password).is_password?(password) }
      puts "[API Access – #{authorized}]: #{app}"

      authorized
    end

    render(json: { reason: "unauthorized" }, status: 401) unless authenticated
  end
end
