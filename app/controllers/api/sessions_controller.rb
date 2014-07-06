module Api
  class SessionsController < ApiController
    respond_to :json
    skip_before_filter :authenticate!, only: :oauth_logout

    def create
      user = User.find_by_email(params[:email])
      if user && user.valid_password?(params[:password]) && user.authorized_for_application_host?(params[:application_host])
        render json: user
      else
        render json: { status: :forbidden }, status: :forbidden
      end
    end

    def oauth_logout
      env["warden"].logout
      head :ok
    end
  end
end
