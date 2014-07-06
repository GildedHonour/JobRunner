module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    public_controller

    def cas
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user
        sign_in_and_redirect user, event: :authentication
      else
        redirect_to user_omniauth_authorize_path(:cas)
      end
    end
  end
end
