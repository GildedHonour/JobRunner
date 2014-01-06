class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :determine_layout

  before_filter :authenticate_user!

  private
  def determine_layout
    user_signed_in? ? "application" : "public"
  end
end