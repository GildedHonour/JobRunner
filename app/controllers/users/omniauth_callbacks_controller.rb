module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    public_controller

    def cas
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user
        sign_in(:user, user, event: :authentication)
        user.process_login!(params[:ticket])

        redirect_to after_sign_in_path_for(user)
      else
        raise "User not found: #{request.env["omniauth.auth"].inspect}"
      end
    end
  end
end
