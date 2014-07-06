class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout
  before_filter :ensure_logged_in
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

  def ensure_logged_in
    redirect_to user_omniauth_authorize_path(:cas) unless user_signed_in?
  end

  def self.public_controller
    skip_before_filter :ensure_logged_in
  end

  protected

  def authenticate_admin!
    unless current_user.try(&:admin?)
      flash[:danger] = "Only admins can access this url."
      redirect_to(root_url) 
    end
  end

  private
  def after_sign_out_path_for(resource_or_scope)
    "#{Rails.application.secrets.cas_url}/logout?" + { service: root_url }.to_query
  end

  def determine_layout
    user_signed_in? ? "application" : "devise"
  end
end
