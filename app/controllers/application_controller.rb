class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout
  before_filter :save_back_url

  before_filter :authenticate_user!

  private
  def determine_layout
    user_signed_in? ? "application" : "public"
  end

  def save_back_url
    if request.get? && request.url != request.referer
      session[:back_url] = request.referer
    end
  end
end