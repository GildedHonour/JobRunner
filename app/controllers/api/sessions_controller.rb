module Api
  class SessionsController < ApiController
    respond_to :json

    def create
      user = User.find_by_email(params[:email])
      if user && user.valid_password?(params[:password])
        render json: user
      else
        render json: { status: :forbidden }, status: :forbidden
      end
    end
  end
end
