module Api
  class SessionsController < ApiController
    respond_to :json
    skip_before_filter :authenticate!, only: :oauth_logout

    def create
      user = User.find_by_email(params[:email])
      if user && user.valid_password?(params[:password]) && user.authorized_for_application?(params[:application])
        render json: UserSerializer.new(user).as_json.merge(authorized_applications: user.authorized_applications.map(&:name))
      else
        render json: { status: :forbidden }, status: :forbidden
      end
    end
  end
end
