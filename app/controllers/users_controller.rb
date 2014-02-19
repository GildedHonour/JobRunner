class UsersController < ApplicationController
  respond_to :js, :html

  def new
    @contact = Contact.find(params[:contact_id])
    @user = @contact.build_user

    respond_with @user
  end

  def create
    @contact = Contact.find(params[:contact_id])
    @user = User.invite!(user_params, current_user) do |user|
      user.contacts << @contact
    end

    @success_message = "The user has been invited." unless @user.errors.present?

    respond_to do |format|
      format.js { render("new") }
    end
  end

  def update
    create and return
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end
end