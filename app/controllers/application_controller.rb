class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout
  before_filter :ensure_logged_in, :check_if_force_logged_out
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

  def self.public_controller
    skip_before_filter :ensure_logged_in, :check_if_force_logged_out
  end

  private
  def authenticate_admin!
    unless current_user.try(&:admin?)
      flash[:danger] = "Only admins can access this url."
      redirect_to(root_url) 
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    "#{Rails.application.secrets.cas_url}/logout?" + { service: root_url }.to_query
  end

  def check_if_force_logged_out
    sign_out_and_redirect(current_user) if user_signed_in? && current_user.force_logout?
  end

  def determine_layout
    user_signed_in? ? "application" : "devise"
  end

  def ensure_logged_in
    redirect_to user_omniauth_authorize_path(:cas) unless user_signed_in?
  end
end
