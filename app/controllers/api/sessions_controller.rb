module Api
  class SessionsController < ApiController
    respond_to :json

    def create
      user = User.find_by_email(params[:email])
      if user && user.valid_password?(params[:password]) && user.authorized_for_application_host?(params[:application_host])
        render json: user
      else
        render json: { status: :forbidden }, status: :forbidden
      end
    end
  end
end
