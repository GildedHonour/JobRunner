class AdminController < ApplicationController
  before_filter :deny_access_unless_admin!

  protected

  def deny_access_unless_admin!
    unless current_user.try(&:admin?)
      flash[:danger] = "Only admin can access this url."
      redirect_to(root_url) 
    end
  end
end