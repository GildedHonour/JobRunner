module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    public_controller

    def failure
      redirect_to root_url
    end

    def cas
      ap request.env["omniauth.auth"]
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end
end
