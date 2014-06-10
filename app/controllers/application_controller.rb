class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout
  before_filter :authenticate_user!
  helper_method :companies_url_with_saved_filters, :contacts_url_with_saved_filters

  def companies_url_with_saved_filters
    companies_url(session[:company_filter_params] || {}) # todo - refactor the key
  end

  def contacts_url_with_saved_filters
    contacts_url(session[:contact_filter_params] || {}) # todo - refactor the key
  end

  def info_for_paper_trail
    { whodunnit_email: current_user.try(:email) }
  end
  
  protected

  def authenticate_admin!
    unless current_user.try(&:admin?)
      flash[:danger] = "Only admins can access this url."
      redirect_to(root_url) 
    end
  end

  private
  
  def determine_layout
    user_signed_in? ? "application" : "devise"
  end
end